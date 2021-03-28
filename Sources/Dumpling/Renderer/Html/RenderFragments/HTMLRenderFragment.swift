//
//  HTMLRenderFragment.swift
//  Dumpling
//
//  Created by Wojciech Chojnacki on 24/03/2021.
//  Copyright © 2021 Dumpling. All rights reserved.
//

import Foundation

public protocol HTMLRenderFragment {
    associatedtype ASTNodeType
    func render(
        _ node: ASTNodeType,
        renderer: HTMLContentRenderer
    ) -> String?
}

public protocol HTMLContentRenderer {
    func render(_ nodes: [ASTNode]) -> String
}
// MARK: -

/// Type erasure type for `AttributedStringRenderFragment` protocol
public struct AnyHTMLRenderFragment: HTMLRenderFragment {
    typealias AnyRenderFragmentFunction = (
        ASTNode,
        HTMLContentRenderer
    ) -> String?

    private let _render: AnyRenderFragmentFunction
    init<F: HTMLRenderFragment>(_ fragment: F) {
        _render = { node, renderer in
            guard let astNode = node as? F.ASTNodeType else {
                fatalError("Wrong node type, expected \(F.ASTNodeType.self) got \(type(of: node))")
            }
            return fragment.render(astNode, renderer: renderer)
        }
    }

    public func render(
        _ node: ASTNode,
        renderer: HTMLContentRenderer
    ) -> String? {
        return _render(node, renderer)
    }
}

extension HTMLRenderFragment {
    func any() -> AnyHTMLRenderFragment {
        AnyHTMLRenderFragment(self)
    }
}
