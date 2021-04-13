//
//  HeaderBlockFragment.swift
//  Dumpling
//
//  Created by Wojciech Chojnacki on 31/05/2020.
//  Copyright © 2020 Wojciech Chojnacki. All rights reserved.
//

import Foundation

public struct HeaderBlockFragment: MarkdownBlockFragment {
    public let identifier: String = "header"
    let maxLevel = 6

    public init() {}

    let lineEnd = Parsers.zip(
        Parsers.zeroOrManySpaces,
        Parsers.newLine.mapToVoid
    ).mapToVoid

    public func build(markdown: MarkdownType) -> Parser<AST.HeaderNode> {
        let start: Parser<Int> = Parsers.zip(
            Parsers.oneOrMany(Parsers.one(character: "#")),
            Parsers.oneOrManySpaces
        ).flatMap {
            let count = $0.0.count
            return count > maxLevel ? Parser<Int>.zero() : .just(count)
        }

        let content = markdown.inline(
            exitParser: lineEnd,
            preExitCheckParser: lineEnd
        )

        return Parsers.zip(
            Parsers.zeroOrManySpaces,
            start,
            content,
            Parsers.oneOf(
                Parsers.emptyLines.mapToVoid,
                lineEnd,
                .just(())
            )
        ).map { _, count, content, _ in
            AST.HeaderNode(size: count, children: content)
        }
    }
}
