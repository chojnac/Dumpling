//
//  LinkNodeRenderFragment.swift
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
public struct LinkNodeRenderFragment: AttributedStringRenderFragment {
    public func render(
        _ node: AST.LinkNode,
        context: AttributedStringRenderer.Context,
        renderer: AttributedStringContentRenderer
    ) -> NSAttributedString? {
        var attributes = context.attributes(forKey: .link)
        let linkValue: String
        switch node.link {
        case .inline(let value):
            linkValue = value
        case .reference(let value):
            linkValue = value
        }
        attributes[.link] = linkValue
        #if canImport(AppKit)
        if let title = node.title {
            attributes[.toolTip] = title
        }
        #endif
        let string = NSMutableAttributedString()
        string.append(
            renderer.render(
                node.children,
                context: context.with(
                    attributes: attributes,
                    pathElement: .link
                )
            )
        )
        string.addAttributes(attributes, range: NSRange(location: 0, length: string.length))
        return string
    }
}
#endif
