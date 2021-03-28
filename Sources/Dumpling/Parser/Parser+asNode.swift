//
//  NewParsers.swift
//  Dumpling
//
//  Created by Wojciech Chojnacki on 29/05/2020.
//  Copyright © 2020 Wojciech Chojnacki. All rights reserved.
//

import Foundation

extension Parser where Element: ASTNode {
    public var asNode: Parser<ASTNode> {
        return .init(self.name) {  self.run(&$0) }
    }
}
