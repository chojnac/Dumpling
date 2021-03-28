//
//  AttributedStringRenderFragment.swift
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
public protocol AttributedStringRenderFragment {
    associatedtype ASTNodeType
    func render(
        _ node: ASTNodeType,
        context: AttributedStringRenderer.Context,
        renderer: AttributedStringContentRenderer
    ) -> NSAttributedString?
}

public protocol AttributedStringContentRenderer {
    func render(_ nodes: [ASTNode], context: AttributedStringRenderer.Context) -> NSAttributedString
}
// MARK: -

/// Type erasure type for `AttributedStringRenderFragment` protocol
public struct AnyAttributedStringRenderFragment: AttributedStringRenderFragment {
    typealias AnyRenderFragmentFunction = (
        ASTNode,
        AttributedStringRenderer.Context,
        AttributedStringContentRenderer
    ) -> NSAttributedString?

    private let _render: AnyRenderFragmentFunction
    init<F: AttributedStringRenderFragment>(_ fragment: F) {
        _render = { node, context, renderer in
            guard let astNode = node as? F.ASTNodeType else {
                fatalError("Wrong node type, expected \(F.ASTNodeType.self) got \(type(of: node))")
            }
            return fragment.render(astNode, context: context, renderer: renderer)
        }
    }

    public func render(
        _ node: ASTNode,
        context: AttributedStringRenderer.Context,
        renderer: AttributedStringContentRenderer
    ) -> NSAttributedString? {
        return _render(node, context, renderer)
    }
}

extension AttributedStringRenderFragment {
    func any() -> AnyAttributedStringRenderFragment {
        AnyAttributedStringRenderFragment(self)
    }
}
#endif
