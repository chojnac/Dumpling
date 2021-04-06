//
//  EmInlineFragment.swift
//  Dumpling
//
//  Created by Wojciech Chojnacki on 06/04/2021.
//  Copyright © 2021 Dumpling. All rights reserved.
//

import Foundation

public struct EmInlineFragment: MarkdownInlineFragment {
    let parser1: EnclosedInlineFragment
    let parser2: EnclosedInlineFragment

    public var identifier: String = "em"

    public init() {
        parser1 = EnclosedInlineFragment(id: identifier, str: "*")
        parser2 = EnclosedInlineFragment(id: identifier, str: "_")
    }

    public func build(markdown: MarkdownType) -> Parser<AST.StyleNode> {
        return Parsers.oneOf(
            parser1.build(markdown: markdown),
            parser2.build(markdown: markdown)
        )
    }
}
