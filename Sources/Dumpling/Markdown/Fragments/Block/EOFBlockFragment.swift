//
//  EOFBlockFragment.swift
//  Dumpling
//
//  Created by Wojciech Chojnacki on 31/05/2020.
//  Copyright © 2020 Wojciech Chojnacki. All rights reserved.
//

import Foundation

public struct EOFBlockFragment: MarkdownBlockFragment {
    public let identifier: String = "eof"
    
    public func build(markdown: MarkdownType) -> Parser<AST.EOFNode> {
        Parsers.zip(
            Parsers.oneOf(
                Parsers.emptyLines,
                Parsers.newLine.mapTo(1),
                .just(0)
            ),
            Parsers.isDocEnd
        ).mapTo(AST.EOFNode())
    }
}
