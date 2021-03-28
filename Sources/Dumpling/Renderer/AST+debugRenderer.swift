//
//  AST+debugRenderer.swift
//  Dumpling
//
//  Created by Wojciech Chojnacki on 30/11/2019.
//  Copyright © 2019 Wojciech Chojnacki. All rights reserved.
//

import Foundation

extension AST.RootNode {
    public func debugString() -> String {
        DebugTextRenderer().render(self)
    }
}
