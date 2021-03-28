//
//  DebugTextRendered.swift
//  Dumpling
//
//  Created by Wojciech Chojnacki on 16/01/2019.
//  Copyright © 2019 Wojciech Chojnacki. All rights reserved.
//

import Foundation

public struct DebugTextRenderer: Renderer {
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
            render(node: element, chunks: &chunks)
        case let element as AST.HeaderNode:
            render(node: element, chunks: &chunks)
        case let element as AST.ParagraphNode:
            render(node: element, chunks: &chunks)
        case let element as AST.LinkNode:
            render(node: element, chunks: &chunks)
        case let element as AST.CodeNode:
            render(node: element, chunks: &chunks)
        case let element as AST.ListNode:
            render(node: element, chunks: &chunks)
        case let element as AST.ListElementNode:
            render(node: element, chunks: &chunks)
        case is AST.NewLineNode:
            chunks.append("⏎")
        case is AST.SpaceNode:
            chunks.append("␣")
        default:
            break
        }
    }

    private func render(node: AST.StyleNode, chunks: inout [String]) {
        render(html: node.id, children: node.children, chunks: &chunks)
    }

    private func render(node: AST.ParagraphNode, chunks: inout [String]) {
        render(html: "p", children: node.children, chunks: &chunks)
    }

    private func render(node: AST.HeaderNode, chunks: inout [String]) {
        render(html: "h\(node.size)", children: node.children, chunks: &chunks)
    }

    private func render(node: AST.LinkNode, chunks: inout [String]) {
        chunks.append("<link")

        if let title = node.title {
            chunks.append(" title=\"\(title)\"")
        }

        switch node.link {
        case let .inline(link):
            chunks.append(" uri=\"\(link)\"")
        case let .reference(ref):
            chunks.append(" ref=\"\(ref)\"")
        }

        chunks.append(">")
        render(node.children, chunks: &chunks)
        chunks.append("</link>")
    }

    private func render(node: AST.CodeNode, chunks: inout [String]) {
        chunks.append("<code")

        if let params = node.params, !params.isEmpty {
            chunks.append(" params=\"\(params)\"")
        }

        chunks.append(">")
        render(node.children, chunks: &chunks)
        chunks.append("</code>")
    }

    private func render(node: AST.ListNode, chunks: inout [String]) {
        let tagName: String
        let start: Int?
        switch node.kind {
        case .bullet:
            tagName = "ul"
            start = nil
        case .ordered(let value, _):
            tagName = "ol"
            start = value
        }
        chunks.append("<\(tagName)")
        chunks.append(" l=\(node.level)")
        if let value = start {
            chunks.append(" start=\(value)")
        }
        chunks.append(">")
        render(node.children, chunks: &chunks)
        chunks.append("</\(tagName)>")
    }

    private func render(node: AST.ListElementNode, chunks: inout [String]) {
        chunks.append("<li>")
        render(node.children, chunks: &chunks)
        chunks.append("</li>")
    }

    private func render(html: String, children: [ASTNode], chunks: inout [String]) {
        chunks.append("<\(html)>")
        render(children, chunks: &chunks)
        chunks.append("</\(html)>")
    }

    private func render(_ nodes: [ASTNode], chunks: inout [String]) {
        for node in nodes {
            render(node, chunks: &chunks)
        }
    }
}
