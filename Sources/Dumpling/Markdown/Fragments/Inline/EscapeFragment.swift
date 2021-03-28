//
//  EscapeInlineFragment.swift
//  Dumpling
//
//  Created by Wojciech Chojnacki on 30/05/2020.
//  Copyright © 2020 Wojciech Chojnacki. All rights reserved.
//

import Foundation

public struct EscapeInlineFragment: MarkdownInlineFragment {
    public let identifier: String = "escape"
    let escapedCharacters: CharacterSet = .init(charactersIn: #"\`*_{}[]()>#+-.!~"#)

    public func build(markdown: MarkdownType) -> Parser<AST.TextNode> {
        Parsers.zip(
            Parsers.one(character: "\\"),
            Parsers.char(inSet: escapedCharacters)
        ).map { _, char in
            return AST.TextNode(String(char))
        }
    }
}
