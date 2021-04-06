//
//  HorizontalLineBlockFragment.swift
//  Dumpling
//
//  Created by Wojciech Chojnacki on 05/04/2021.
//  Copyright © 2021 Dumpling. All rights reserved.
//

import Foundation

public struct HorizontalLineBlockFragment: MarkdownBlockFragment {
    public let identifier: String = "para"

    public init() {}
    
    public func build(markdown: MarkdownType) -> Parser<AST.HorizontalLineNode> {

        let line = Parsers.oneOf(
            Self.lineParser("-"),
            Self.lineParser("*"),
            Self.lineParser("_")
        )

        return Parsers.zip(
            Parsers.lineStart,
            Parsers.minMax(parser: Parsers.space, min: 0, max: 3),
            line,
            Parsers.oneOf(Parsers.newLine, Parsers.isDocEnd)
        ).mapTo(AST.HorizontalLineNode())

    }

    static func lineParser(_ character: Character) -> Parser<Void> {
        let content = Parsers.zip(
            Parsers.one(character: character),
            Parsers.zeroOrManySpaces
        ).mapToVoid

        return Parsers.minMax(
            parser: content,
            min: 3
        ).mapToVoid
    }
}
