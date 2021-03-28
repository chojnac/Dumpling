//
//  ParaBlockFragment.swift
//  Dumpling
//
//  Created by Wojciech Chojnacki on 30/05/2020.
//  Copyright © 2020 Wojciech Chojnacki. All rights reserved.
//

import Foundation

public struct ParaBlockFragment: MarkdownBlockFragment {
    public let identifier: String = "para"
    
    public func build(markdown: MarkdownType) -> Parser<AST.ParagraphNode> {
        return Parsers.zip(
            Parsers.zeroOrManySpaces, //remove start spaces
            Parsers.emptyLines,
            Parsers.zeroOrManySpaces
        ).mapTo(AST.ParagraphNode(children: []))
    }
}
