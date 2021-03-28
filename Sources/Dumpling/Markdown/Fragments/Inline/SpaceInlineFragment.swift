//
//  SpaceInlineFragment.swift
//  Dumpling
//
//  Created by Wojciech Chojnacki on 27/03/2021.
//  Copyright © 2021 Dumpling. All rights reserved.
//

import Foundation

struct SpaceInlineFragment: MarkdownInlineFragment {
    public let identifier: String = "space"

    func build(markdown: MarkdownType) -> Parser<AST.SpaceNode> {
        Parsers.oneOrManySpaces.map(AST.SpaceNode.init(count:))
    }
}
