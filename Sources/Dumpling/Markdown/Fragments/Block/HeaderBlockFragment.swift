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

    public func build(markdown: MarkdownType) -> Parser<AST.HeaderNode> {
        let start: Parser<Int> = Parsers.zip(
            Parsers.oneOrMany(Parsers.one(character: "#")),
            Parsers.oneOrManySpaces
        ).flatMap {
            let count = $0.0.count
            return count > 5 ? Parser<Int>.zero() : .just(count)
        }

        let stop = Parsers.newLine.mapToVoid
        let content = markdown.inline(
            exitParser: stop,
            preExitCheckParser: stop
        )

        return Parsers.zip(
            Parsers.zeroOrManySpaces,
            start,
            content,
            Parsers.oneOf(
                Parsers.emptyLines,
                Parsers.newLine.mapTo(1),
                .just(0)
            )
        ).map { _, count, content, _ in
            AST.HeaderNode(size: count, children: content)
        }
    }
}
