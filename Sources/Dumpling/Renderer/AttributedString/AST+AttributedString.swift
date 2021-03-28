//
//  AST+AttributedString.swift
//  Dumpling
//
//  Created by Wojciech Chojnacki on 21/03/2021.
//  Copyright © 2021 Dumpling. All rights reserved.
//

import Foundation

#if canImport(UIKit) || canImport(AppKit)
extension AST.RootNode {
    public func renderAttributedString(theme: AttributedStringTheme = .default) -> NSAttributedString {
        AttributedStringRenderer(theme: theme).render(self)
    }
}
#endif
