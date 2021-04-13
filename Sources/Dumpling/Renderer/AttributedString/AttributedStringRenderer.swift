//
//  AttributedStringRenderer.swift
//  Dumpling
//
//  Created by Wojciech Chojnacki on 12/01/2019.
//  Copyright © 2019 Wojciech Chojnacki. All rights reserved.
//

import Foundation
#if canImport(UIKit)
    import UIKit
#elseif canImport(AppKit)
    import AppKit
#endif

#if canImport(UIKit) || canImport(AppKit)
public typealias StringAttributesType = [NSAttributedString.Key: Any]

public class AttributedStringRenderer: Renderer {
    /// Helper type preventing exposing `HTMLRenderer::render(_ nodes: [ASTNode])` in the public interface
    private struct ContentRenderer: AttributedStringContentRenderer {
        let renderer: AttributedStringRenderer
        func render(_ nodes: [ASTNode], context: AttributedStringRenderer.Context) -> NSAttributedString {
            renderer.render(nodes, context: context)
        }
    }

    private var contentRenderer: ContentRenderer!
    private let theme: AttributedStringTheme
    private var nodeRenderer: [String: AnyAttributedStringRenderFragment] = [:]

    public init(theme: AttributedStringTheme) {
        self.theme = theme
        nodeRenderer = [
            AST.EOFNode.typeName: NothingNodeRenderFragment().any(),
            AST.NewLineNode.typeName: NewLineNodeRenderFragment().any(),
            AST.StyleNode.typeName: StyleNodeRenderFragment().any(),
            AST.TextNode.typeName: TextNodeRenderFragment().any(),
            AST.SpaceNode.typeName: SpaceNodeRenderFragment().any(),
            AST.ParagraphNode.typeName: ParagraphNodeRenderFragment().any(),
            AST.HeaderNode.typeName: HeaderNodeRenderFragment().any(),
            AST.ListNode.typeName: ListNodeRenderFragment().any(),
            AST.LinkNode.typeName: LinkNodeRenderFragment().any(),
            AST.CodeNode.typeName: CodeNodeRenderFragment().any(),
            AST.HorizontalLineNode.typeName: HorizontalLineNodeRenderFragment().any(),
        ]

        contentRenderer = ContentRenderer(renderer: self)
    }

    public func registerRenderFragment<F: AttributedStringRenderFragment>(fragment: F) where F.ASTNodeType: ASTNode {
        nodeRenderer[F.ASTNodeType.typeName] = fragment.any()
    }

    func render(_ nodes: [ASTNode], context: AttributedStringRenderer.Context) -> NSAttributedString {
        let result = NSMutableAttributedString()
        for node in nodes {
            guard let fragment = nodeRenderer[node.typeName] else {
                print("Unsupported node type \(type(of: node.self))")
                continue
            }

            if let text = fragment.render(node, context: context, renderer: contentRenderer) {
                result.append(text)
            }
        }
        return result
    }

    public func render(_ ast: AST.RootNode) -> NSAttributedString {
        let context = AttributedStringRenderer.Context(theme: theme)
        return render(ast.children, context: context)
    }

}

#endif
