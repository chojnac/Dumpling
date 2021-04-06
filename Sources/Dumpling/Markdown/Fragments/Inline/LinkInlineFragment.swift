//
//  LinkInlineFragment.swift
//  Dumpling
//
//  Created by Wojciech Chojnacki on 31/05/2020.
//  Copyright © 2020 Wojciech Chojnacki. All rights reserved.
//

import Foundation

public struct LinkInlineFragment: MarkdownInlineFragment {
    public let identifier: String = "link"

    public init() {}
    
    public func build(markdown: MarkdownType) -> Parser<AST.LinkNode> {
        Parsers.zip(
            Parsers.minMax(parser: Parsers.one(character: "!"), min: 0, max: 1),
            Self.balancedBrackets("["),
            Self.linkSource()
        ).map { _, text, source in
            AST.LinkNode(text: text, link: source.0, title: source.1)
        }
    }
}

extension LinkInlineFragment {
    static let stopCharactersSet = CharacterSet(charactersIn: "\n\t")

    static func closeTag(_ open: Character) -> Character {
        switch open {
        case "(":
            return ")"
        case "[":
            return "]"
        case "{":
            return "}"
        case "<":
            return ">"
        case "'":
            return "'"
        case "\"":
            return "\""
        default:
            fatalError("Unsupported character - only allowed \"({[<\"")
        }
    }
    private enum Token {
        case openTag
        case closeTag
        case stop
        case character(Character)
    }

    static func balancedBrackets(_ open: Character) -> Parser<String> {
        let escapedCharacters = CharacterSet(charactersIn: #"\`*_{}[]()>#+-.!~"#)
        
        let closeCharacter = closeTag(open)
        let isSameOpenCloseTag = closeCharacter == open

        let escaped = Parsers.zip(
            Parsers.one(character: "\\"),
            Parsers.char(inSet: escapedCharacters)
        ).map {
            Token.character($0.1)
        }

        let stepParser = Parsers.oneOf(
            Parsers.one(character: open).map({ _ in Token.openTag}),
            escaped,
            Parsers.one(character: closeCharacter).map({ _ in Token.closeTag }),
            Parsers.char(inSet: stopCharactersSet).map({ _ in Token.stop }),
            Parsers.anyCharacter.map({ Token.character($0) })
        )

        return .init("balancedBrackets:\(open)") { reader in
            let origin = reader
            var balanceOpenTagsCount = 0
            var accumulator = [Character]()

            repeat {
                guard let result = stepParser.run(&reader) else {
                    reader = origin
                    return nil
                }

                let stepResult: Token

                if isSameOpenCloseTag, case .openTag = result, balanceOpenTagsCount == 1 {
                    stepResult = .closeTag
                } else {
                    stepResult = result
                }

                switch stepResult {
                case .openTag:
                    if balanceOpenTagsCount > 0 {
                        accumulator.append(open)
                    }
                    balanceOpenTagsCount += 1

                case .closeTag:
                    balanceOpenTagsCount -= 1
                    if balanceOpenTagsCount < 0 {
                        reader = origin
                        return nil
                    } else if balanceOpenTagsCount == 0 {
                        return String(accumulator)
                    } else {
                        accumulator.append(closeCharacter)
                    }
                case .stop:
                    reader = origin
                    return nil
                case .character(let value):
                    if balanceOpenTagsCount == 0 {
                        reader = origin
                        return nil // character without open tag makes no sense, so exit
                    }
                    accumulator.append(value)
                }
            } while true

        }
    }

    private static func linkType(_ str: String) -> AST.LinkNode.LinkValue {
        if str.starts(with: "#") {
            return AST.LinkNode.LinkValue.reference(str)
        }

        return AST.LinkNode.LinkValue.inline(str)
    }

    static func processSourceString(_ str: String) -> (AST.LinkNode.LinkValue, String?)? {
        let input = str.trimmingCharacters(in: .whitespaces)
        guard !input.isEmpty else {
            return (linkType(""), nil)
        }

        var reader = Substring(input)

        let source = Parsers.oneOf(
            balancedBrackets("<"),
            Parsers.stringUntil(stop: Parsers.space)
        )

        if let result = source.run(&reader), reader.isEmpty {
            return (linkType(result), nil)
        }

        reader = Substring(input)

        let title = Parsers.oneOf(
            balancedBrackets("\""),
            balancedBrackets("'"),
            balancedBrackets("(")
        )

        let parser = Parsers.zip(
            Parsers.isDocStart,
            source,
            Parsers.oneOrManySpaces,
            title,
            Parsers.isDocEnd
        ).map { _, source, _, title, _ in (source: source, title: title) }

        return parser.run(&reader).map {
            return (linkType($0.source), $0.title)
        }
    }

    static func linkSource() -> Parser<(AST.LinkNode.LinkValue, String?)> {
        balancedBrackets("(").flatMap { str -> Parser<(AST.LinkNode.LinkValue, String?)> in
            if let result = processSourceString(str) {
                return .just(result)
            }

            return .zero()
        }
    }
}
