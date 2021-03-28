//
//  AST+PlainTextRenderer.swift
//  Dumpling
//
//  Created by Wojciech Chojnacki on 13/01/2019.
//  Copyright © 2019 Wojciech Chojnacki. All rights reserved.
//

import Foundation

extension AST.RootNode {
    public func renderPlainText() -> String {
        PlainTextRenderer().render(self)
    }
}
