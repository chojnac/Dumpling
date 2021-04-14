//
//  BlockquoteNodeRenderFragment.swift
//  Dumpling
//
//  Created by Wojciech Chojnacki on 06/04/2021.
//  Copyright © 2021 Dumpling. All rights reserved.
//

import Foundation
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

#if canImport(UIKit) || canImport(AppKit)
public struct BlockquoteNodeRenderFragment: AttributedStringRenderFragment {
    public func render(
        _ node: AST.BlockquoteNode,
        context: AttributedStringRenderer.Context,
        renderer: AttributedStringContentRenderer
    ) -> NSAttributedString? {
        var attributes: StringAttributesType = context.attributes(forKey: .blockquote)
        let level = context.path.filter({ $0 == .blockquote }).count
        attributes[.blockquoteLevel] = level
        let attributedString = NSMutableAttributedString()

        attributedString.append(
            renderer.render(
                node.children,
                context: context.with(
                    attributes: attributes,
                    pathElement: .blockquote,
                    ident: true
                )
            )
        )
        attributedString.append(NSAttributedString(string: "", attributes: attributes))
        return attributedString
    }
}
extension NSAttributedString.Key {
    public static let blockquoteLevel = NSAttributedString.Key("dumpling_blockquote_level")
}

#endif
