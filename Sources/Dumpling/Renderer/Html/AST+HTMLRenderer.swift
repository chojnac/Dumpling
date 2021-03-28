//
//  AST+HTMLRenderer.swift
//  Dumpling
//
//  Created by Wojciech Chojnacki on 12/12/2019.
//  Copyright © 2019 Wojciech Chojnacki. All rights reserved.
//

import Foundation

extension AST.RootNode {
    public func renderHTML() -> String {
        HTMLRenderer().render(self)
    }
}
