//
//  PlainTextRenderer.swift
//  Dumpling
//
//  Created by Wojciech Chojnacki on 10/01/2019.
//  Copyright © 2019 Wojciech Chojnacki. All rights reserved.
//

import Foundation

public struct PlainTextRenderer: Renderer {
    public init() {}

    public func render(_ ast: AST.RootNode) -> String {
        var chunks = [String]()
        render(ast, chunks: &chunks)

        return chunks.joined()
    }

    private func render(_ node: ASTNode, chunks: inout [String]) {
        switch node {
        case let element as AST.TextNode:
            chunks.append(element.text)
        case let element as AST.RootNode:
            render(element.children, chunks: &chunks)
        case let element as AST.StyleNode:
            render(tagNode: element, chunks: &chunks)
        case let element as AST.NewLineNode:
            render(tagNode: element, chunks: &chunks)
        case let element as AST.SpaceNode:
            render(tagNode: element, chunks: &chunks)
        case let element as AST.ParagraphNode:
            render(tagNode: element, chunks: &chunks)
        case let element as AST.LinkNode:
            render(tagNode: element, chunks: &chunks)
        default:
            break
        }
    }

    private func render(tagNode _: AST.NewLineNode, chunks: inout [String]) {
        chunks.append("\n")
    }

    private func render(tagNode _: AST.SpaceNode, chunks: inout [String]) {
        chunks.append(" ")
    }

    private func render(tagNode: AST.ParagraphNode, chunks: inout [String]) {
        render(tagNode.children, chunks: &chunks)
    }

    private func render(tagNode: AST.LinkNode, chunks: inout [String]) {
        render(tagNode.children, chunks: &chunks)
    }

    private func render(tagNode: AST.StyleNode, chunks: inout [String]) {
        render(tagNode.children, chunks: &chunks)
    }

    private func render(_ nodes: [ASTNode], chunks: inout [String]) {
        for node in nodes {
            render(node, chunks: &chunks)
        }
    }
}
