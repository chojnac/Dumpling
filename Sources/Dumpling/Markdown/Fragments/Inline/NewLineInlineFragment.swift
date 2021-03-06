//
//  NewLineInlineFragment.swift
//  Dumpling
//
//  Created by Wojciech Chojnacki on 27/03/2021.
//  Copyright © 2021 Dumpling. All rights reserved.
//

import Foundation

struct NewLineInlineFragment: MarkdownInlineFragment {
    public let identifier: String = "newLine"
    
    func build(markdown: MarkdownType) -> Parser<AST.NewLineNode> {
        Parsers.zip(
            Parsers.zeroOrManySpaces,
            Parsers.newLine
        ).map { count, _ in
            AST.NewLineNode(soft: count < 2 )
        }
    }
}
