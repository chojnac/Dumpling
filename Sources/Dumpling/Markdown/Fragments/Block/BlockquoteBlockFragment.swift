//
//  BlockquoteBlockFragment.swift
//  Dumpling
//
//  Created by Wojciech Chojnacki on 06/04/2021.
//  Copyright © 2021 Dumpling. All rights reserved.
//

import Foundation

public struct BlockquoteBlockFragment: MarkdownBlockFragment {
    public let identifier: String = "blockquote"

    public func build(markdown: MarkdownType) -> Parser<AST.BlockquoteNode> {

        let contentParser = self.contentParser()

        return .init(identifier) { reader in
            guard let (content, depth) = contentParser.run(&reader) else {
                return nil
            }

            var children = [ASTNode]()
            let result = markdown.block(content)
            if !result.isEmpty {
                children.append(contentsOf: result)
            } else {
                children.append(AST.TextNode(content))
            }

            return (1..<depth).reduce(AST.BlockquoteNode(children: children)) { node, _ in
                AST.BlockquoteNode(children: [node])
            }
        }
    }

    private func parse(content: String, contentParser: Parser<String>) -> AST.BlockquoteNode? {
        var nestedReader = Substring(content)
        guard let result = contentParser.run(&nestedReader) else {
            return nil
        }

        var children = [ASTNode]()

        if let child = parse(content: result, contentParser: contentParser) {
            children.append(child)
        } else {
            children.append(AST.TextNode(content))
        }
        
        return AST.BlockquoteNode(children: children)
    }

    let indicator = Parsers.zip(
        Parsers.minMax(parser: Parsers.space, min: 0, max: 3).map(\.count),
        Parsers.one(character: ">"),
        Parsers.zeroOrManySpaces
    ).map {
        OpeningIndicatorInfo(preSpacesCount: $0, postSpacesCount: $2)
    }

    func contentParser() -> Parser<(String, Int)> {
        let opening = Parsers.zip(
            Parsers.lineStart,
            Parsers.oneOrMany(indicator),
            Parsers.stringUntil(stop: Parsers.lineEnd),
            Parsers.lineEnd
        ).map { _, indicators, content, _ in
            FirstLine(indicators: indicators, content: content)
        }

        return .init("content") { reader in
            guard let firstLine = opening.run(&reader) else {
                return nil
            }

            let nextLineParser = self.nextLineParser(maxLevel: firstLine.depth)

            var content = [firstLine.content]

            repeat {
                guard !reader.isEmpty else {
                    break
                }

                if Parsers.singleEmptyLine.run(&reader) != nil {
                    break
                }

                guard let line = nextLineParser.run(&reader) else {
                    break
                }
                content.append(line)
            } while true

            return (content.joined(separator: "\n"), firstLine.depth)
        }
    }

    private func nextLineParser(maxLevel: Int) -> Parser<String> {
        Parsers.zip(
            Parsers.lineStart,
            Parsers.minMax(parser: indicator, min: 0, max: UInt(maxLevel)),
            Parsers.stringUntil(stop: Parsers.lineEnd),
            Parsers.lineEnd
        ).map(\.2)
    }

    struct OpeningIndicatorInfo {
        let preSpacesCount: Int
        let postSpacesCount: Int
    }

    struct FirstLine {
        let depth: Int
        let content: String

        init(indicators: [OpeningIndicatorInfo], content: String) {
            depth = indicators.count
            self.content = content
        }
    }
}
