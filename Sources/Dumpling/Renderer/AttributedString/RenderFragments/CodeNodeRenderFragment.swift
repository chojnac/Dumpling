//
//  CodeNodeRenderFragment.swift
//  Dumpling
//
//  Created by Wojciech Chojnacki on 23/03/2021.
//  Copyright © 2021 Dumpling. All rights reserved.
//

import Foundation
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

#if canImport(UIKit) || canImport(AppKit)
public struct CodeNodeRenderFragment: AttributedStringRenderFragment {
    public func render(
        _ node: AST.CodeNode,
        context: AttributedStringRenderer.Context,
        renderer: AttributedStringContentRenderer
    ) -> NSAttributedString? {
        
        var attributes: StringAttributesType
        if node.isBlock {
            let key = AttributedStringTheme.StyleKey.codeBlock
            attributes = context.attributes(forKey: key)
        } else {
            let key = AttributedStringTheme.StyleKey.code
            attributes = context.attributes(forKey: key)
        }
        
        let attributedString = NSMutableAttributedString()
        attributedString.append(renderer.render(node.children, context: context.with(attributes: attributes)))
        if node.isBlock {
            attributedString.append(NSAttributedString(string: "\n", attributes: attributes))
        }
        
        attributedString.addAttributes(attributes, range: NSRange(location: 0, length: attributedString.length))
        return attributedString
    }
}
#endif
