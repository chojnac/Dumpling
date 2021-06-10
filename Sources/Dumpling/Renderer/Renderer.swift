//
//  Renderer.swift
//  Dumpling
//
//  Created by Wojciech Chojnacki on 12/01/2019.
//  Copyright © 2019 Wojciech Chojnacki. All rights reserved.
//

import Foundation

public protocol Renderer {
    associatedtype Output

    func render(_ ast: AST.RootNode) -> Output
}
