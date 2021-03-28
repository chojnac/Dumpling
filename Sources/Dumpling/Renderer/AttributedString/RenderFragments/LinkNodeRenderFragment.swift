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
        return renderer.render(node.children, context: context)
    }
}
#endif
