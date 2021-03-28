//
//  Array+AST.swift
//  Dumpling
//
//  Created by Wojciech Chojnacki on 11/12/2019.
//  Copyright © 2019 Wojciech Chojnacki. All rights reserved.
//

import Foundation

extension Array where Element == ASTNode {
    mutating func appendIfTextNotEmpty(_ textNode: AST.TextNode) {
        guard !textNode.text.isEmpty else { return }
        append(textNode)
    }
}
