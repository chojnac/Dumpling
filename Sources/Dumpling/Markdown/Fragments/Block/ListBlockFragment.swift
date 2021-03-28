//
//  ListBlockFragment.swift
//  Dumpling
//
//  Created by Wojciech Chojnacki on 11/03/2021.
//  Copyright © 2021 Wojciech Chojnacki. All rights reserved.
//

import Foundation

public struct ListBlockFragment: MarkdownBlockFragment {
    public let identifier: String = "list"
    static let indicator = CharacterSet(charactersIn: "*+-")
    static let zeroOrMax3Spaces = Parsers.minMax(parser: Parsers.space, min: 0, max: 3).map(\.count)

    public func build(markdown: MarkdownType) -> Parser<AST.ListNode> {
        Self.list(level: 0, identCount: 0, markdown: markdown, parentsOpenings: [])
    }
}

///
/// parentsOpenings - list of parsers for opening clause (` *`) for parent level. This way when we parse nested (inline) content we know when to break parsing because we reach end of level. This was neccessary for cases when there is an exit from nested list:
/// ``` * Level 1a\n   * Level 2\n * Level 1b```
///
extension ListBlockFragment {

    static func nextLineSameLevel(
        kind: AST.ListNode.Kind,
        identCount: Int,
        markdown: MarkdownType,
        parentsOpenings: [Parser<Void>]
    ) -> Parser<(identCount: Int, content: [ASTNode])> {

        let openingSequence = openingSequenceParser(identCount: identCount, type: kind)

        let contentParser = inlineContentParser(
            openingSequenceParsers: parentsOpenings + [openingSequence.mapToVoid],
            markdown: markdown
        )
        
        return Parsers.zip(
            openingSequence,
            contentParser
        ).map { initialSequence, content in
            (identCount: identCount + initialSequence.contentIdent, content: content)
        }
    }

    static func openingSequenceParser(
        identCount: Int,
        type: AST.ListNode.Kind? = nil
    ) -> Parser<(spacesCountPre: Int, spacesCountPost: Int, contentIdent: Int, type: AST.ListNode.Kind)> {

        let orderedListIndicatorParser = Parsers.zip(
            Parsers.intNumber(),
            Parsers.char(inSet: CharacterSet(charactersIn: ".)"))
                .map(AST.ListNode.Kind.Delimeter.init)
                .unwrap()
        ).map(AST.ListNode.Kind.ordered(start:delimeter:))

        let bulletListIndicatorParser = Parsers.char(inSet: indicator).mapTo(AST.ListNode.Kind.bullet)

        let indicatorParser: Parser<AST.ListNode.Kind>

        if let type = type {
            switch type {
            case .bullet:
                indicatorParser = bulletListIndicatorParser
            case .ordered:
                // check if the delimeted is the same
                indicatorParser = orderedListIndicatorParser.flatMap {
                    $0.isSameType(type) ? .just($0) : .zero()
                }
            }
        } else {
            indicatorParser = Parsers.oneOf(orderedListIndicatorParser, bulletListIndicatorParser)
        }

        return Parsers.zip(
            Parsers.lineStart.mapToVoid,
            Parsers.minMax(
                parser: Parsers.space,
                min: UInt(identCount),
                max: UInt(identCount)
            ), // ident from parent
            zeroOrMax3Spaces,
            indicatorParser,
            Parsers.minMax(parser: Parsers.space, min: 1, max: 3).map(\.count),
            Parsers.not(Parsers.space)
        ).map { _, _, spacesCountPre, listType, spacesCountPost, _ in
            (
                spacesCountPre: spacesCountPre,
                spacesCountPost: spacesCountPost,
                contentIdent: spacesCountPre + spacesCountPost + 1,
                type: listType
            )
        }
    }

    private static func inlineContentParser(
        openingSequenceParsers: [Parser<Void>],
        markdown: MarkdownType
    ) -> Parser<[ASTNode]> {
        let stopParser = Parsers.oneOf(
            Parsers.oneOf(openingSequenceParsers).mapToVoid,
            Parsers.emptyLines.mapToVoid
        ).mapToVoid

        return markdown.inline(exitParser: stopParser, preExitCheckParser: stopParser)
            .map({ elements -> [ASTNode] in
                if let last = elements.last, last is AST.NewLineNode {
                    return Array(elements.dropLast())
                }
                return elements
            })
    }

    static func list(
        level: UInt,
        identCount: Int,
        markdown: MarkdownType,
        parentsOpenings: [Parser<Void>]
    ) -> Parser<AST.ListNode> {
        guard level <= 6 else {
            return .zero()
        }

        let openingSequence = openingSequenceParser(identCount: identCount)

        return .init("list") { reader in
            var listChildren: [AST.ListElementNode] = []

            // First line parsing
            guard let openSequenceResult = openingSequence.run(&reader) else {
                return nil
            }
            let currentListType = openSequenceResult.type

            let nextLevelOpenSequenceParser = openingSequenceParser(
                identCount: openSequenceResult.contentIdent
            ).mapToVoid

            let contentParser = inlineContentParser(
                openingSequenceParsers: parentsOpenings + [openingSequence.mapToVoid, nextLevelOpenSequenceParser],
                markdown: markdown
            )
            guard let firstLineContentResult = contentParser.run(&reader) else {
                return nil
            }

            var firstLineChildren: [ASTNode] = []
            firstLineChildren.append(contentsOf: firstLineContentResult)

            // parse list one level deeper (if exist)
            if let result = list(
                level: level + 1,
                identCount: openSequenceResult.contentIdent + identCount,
                markdown: markdown,
                parentsOpenings: parentsOpenings + [openingSequence.mapToVoid]
            ).run(&reader) {
                firstLineChildren.append(result)
            }

            listChildren.append(AST.ListElementNode(children: firstLineChildren))

            // parse next line on this same level
            let nextLineParser = nextLineSameLevel(
                kind: currentListType,
                identCount: identCount,
                markdown: markdown,
                parentsOpenings: parentsOpenings + [openingSequence.mapToVoid, nextLevelOpenSequenceParser]
            )
            
            repeat {
                guard let nextLineResult = nextLineParser.run(&reader) else {
                    break
                }

                var liChildren: [ASTNode] = []
                liChildren.append(contentsOf: nextLineResult.content)

                if let result = list(
                    level: level + 1,
                    identCount: openSequenceResult.contentIdent + identCount,
                    markdown: markdown,
                    parentsOpenings: parentsOpenings + [openingSequence.mapToVoid]
                ).run(&reader) {
                    liChildren.append(result)
                }
                listChildren.append(AST.ListElementNode(children: liChildren))
            } while true

            return AST.ListNode(
                kind: currentListType,
                level: Int(level),
                children: listChildren
            )
        }
    }
}

extension AST.ListNode.Kind {
    func isSameType(_ value: AST.ListNode.Kind) -> Bool {
        switch (self, value) {
        case (.bullet, .bullet):
            return true
        case (let .ordered(_, lhs), let .ordered(_, rhs)):
            return lhs == rhs
        default:
            return false
        }

    }
}

extension AST.ListNode.Kind.Delimeter {
    init?(_ char: Character) {
        switch char {
        case ".":
            self = .period
        case ")":
            self = .paren
        default:
            return nil
        }
    }
}
