//
//  StrikethroughInlineFragment.swift
//  Dumpling
//
//  Created by Wojciech Chojnacki on 06/04/2021.
//  Copyright © 2021 Dumpling. All rights reserved.
//

import Foundation

public struct StrikethroughInlineFragment: MarkdownInlineFragment {
    let parser: EnclosedInlineFragment

    public var identifier: String = "s"

    public init() {
        parser = EnclosedInlineFragment(id: identifier, str: "~~")
    }

    public func build(markdown: MarkdownType) -> Parser<AST.StyleNode> {
        return parser.build(markdown: markdown)
    }
}
