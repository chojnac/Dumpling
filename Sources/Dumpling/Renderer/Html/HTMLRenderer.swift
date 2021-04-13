//
//  HTMLRenderer.swift
//  Dumpling
//
//  Created by Wojciech Chojnacki on 12/12/2019.
//  Copyright © 2019 Wojciech Chojnacki. All rights reserved.
//

import Foundation

public class HTMLRenderer: Renderer {
    private var nodeRenderer: [String: AnyHTMLRenderFragment] = [:]

    /// Helper type preventing exposing `HTMLRenderer::render(_ nodes: [ASTNode])` in the public interface
    private struct ContentRenderer: HTMLContentRenderer {
        let renderer: HTMLRenderer
        func render(_ nodes: [ASTNode]) -> String {
            renderer.render(nodes)
        }
    }

    private var contentRenderer: ContentRenderer!

    public init() {
        nodeRenderer = [
            AST.EOFNode.typeName: NothingNodeHTMLRenderFragment().any(),
            AST.NewLineNode.typeName: NewLineNodeHTMLRenderFragment().any(),
            AST.StyleNode.typeName: StyleNodeHTMLRenderFragment().any(),
            AST.TextNode.typeName: TextNodeHTMLRenderFragment().any(),
            AST.SpaceNode.typeName: SpaceNodeHTMLRenderFragment().any(),
            AST.ParagraphNode.typeName: ParagraphHTMLNodeRenderFragment().any(),
            AST.HeaderNode.typeName: HeaderNodeHTMLRenderFragment().any(),
            AST.ListNode.typeName: ListNodeHTMLRenderFragment().any(),
            AST.LinkNode.typeName: LinkNodeHTMLRenderFragment().any(),
            AST.CodeNode.typeName: CodeNodeHTMLRenderFragment().any(),
            AST.HorizontalLineNode.typeName: HorizontalLineNodeHTMLRenderFragment().any(),
        ]

        contentRenderer = ContentRenderer(renderer: self)
    }

    public func registerRenderFragment<F: HTMLRenderFragment>(fragment: F) where F.ASTNodeType: ASTNode {
        nodeRenderer[F.ASTNodeType.typeName] = fragment.any()
    }

    public func render(_ ast: AST.RootNode) -> String {
        return render(ast.children)
    }

    func render(_ nodes: [ASTNode]) -> String {
        var chunks = [String]()
        for node in nodes {
            guard let fragment = nodeRenderer[node.typeName] else {
                print("Unsupported node type \(type(of: node.self))")
                continue
            }

            if let text = fragment.render(node, renderer: contentRenderer) {
                chunks.append(text)
            }
        }
        return chunks.joined()
    }
}
