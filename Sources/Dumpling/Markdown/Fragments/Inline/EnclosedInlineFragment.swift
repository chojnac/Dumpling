//
//  EnclosedInlineFragment.swift
//  Dumpling
//
//  Created by Wojciech Chojnacki on 30/05/2020.
//  Copyright © 2020 Wojciech Chojnacki. All rights reserved.
//

import Foundation

public struct EnclosedInlineFragment: MarkdownInlineFragment {
    public let identifier: String
    let str: String

    public init(id: String, str: String) {
        self.identifier = id
        self.str = str
    }

    public func build(markdown: MarkdownType) -> Parser<AST.StyleNode> {
        
        let opening = Parsers.zip(
            Parsers.starts(with: str),
            Parsers.notFollowedBy(
                Parsers.oneOf(
                    Parsers.space.mapToVoid,
                    Parsers.zip(
                        Parsers.zeroOrManySpaces,
                        Parsers.newLine,
                        Parsers.zeroOrManySpaces
                    ).mapToVoid
                )
            )
        )

        let closing = Parsers.zip(
            Parsers.not(
                Parsers.oneOf(
                    Parsers.space,
                    Parsers.lineStart
                )
            ),
            Parsers.starts(with: str)
        ).mapToVoid
        
        let content = markdown.inline(
            exitParser: closing,
            preExitCheckParser: nil
        )
        
        return Parsers.zip(
            opening,
            content,
            closing
        ).map { _, content, _ in
            return AST.StyleNode(id: identifier, children: content)
        }
    }
}
