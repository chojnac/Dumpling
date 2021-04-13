//
//  HTMLRenderFragments.swift
//  Dumpling
//
//  Created by Wojciech Chojnacki on 24/03/2021.
//  Copyright © 2021 Dumpling. All rights reserved.
//

import Foundation

public struct StyleNodeHTMLRenderFragment: HTMLRenderFragment {
    public func render(
        _ node: AST.StyleNode,
        renderer: HTMLContentRenderer
    ) -> String? {
        let tag = node.id
        var chunks = [String]()
        chunks.append("<\(tag)>")
        let content = renderer.render(node.children)
        chunks.append(content)
        chunks.append("</\(tag)>")
        return chunks.joined()
    }
}

public struct HeaderNodeHTMLRenderFragment: HTMLRenderFragment {
    public func render(
        _ node: AST.HeaderNode,
        renderer: HTMLContentRenderer
    ) -> String? {
        let tag = "h\(node.size)"
        var chunks = [String]()
        chunks.append("\n<\(tag)>")
        let content = renderer.render(node.children)
        chunks.append(content)
        chunks.append("</\(tag)>\n")
        return chunks.joined()
    }
}

public struct TextNodeHTMLRenderFragment: HTMLRenderFragment {
    public func render(
        _ node: AST.TextNode,
        renderer: HTMLContentRenderer
    ) -> String? {
        let characterEntities: [Character: String] = ["\"": "&quot;",
                                 "&": "&amp;",
                                 "'": "&apos;",
                                 "<": "&lt;",
                                 ">": "&gt;"]
        var result = ""

        var reader = node.text[...]
        var textBuffer = reader
        repeat {
            if let ch = reader.first {
                if let value = characterEntities[ch] {
                    result.append(String(textBuffer[..<reader.startIndex]))
                    result.append(value)
                    reader = reader.dropFirst()
                    textBuffer = reader
                    continue
                }
            }

            reader = reader.dropFirst()

        } while !reader.isEmpty
        result.append(String(textBuffer))

        return result
    }
}

public struct SpaceNodeHTMLRenderFragment: HTMLRenderFragment {
    public func render(
        _ node: AST.SpaceNode,
        renderer: HTMLContentRenderer
    ) -> String? {
        " "
    }
}

public struct ParagraphHTMLNodeRenderFragment: HTMLRenderFragment {
    public func render(
        _ node: AST.ParagraphNode,
        renderer: HTMLContentRenderer
    ) -> String? {
        var chunks = [String]()
        chunks.append("\n<p>")
        let content = renderer.render(node.children)
        chunks.append(content)
        chunks.append("</p>\n")
        return chunks.joined()
    }
}

public struct LinkNodeHTMLRenderFragment: HTMLRenderFragment {
    public func render(
        _ node: AST.LinkNode,
        renderer: HTMLContentRenderer
    ) -> String? {
        var chunks = [String]()
        chunks.append("<a")

        if let title = node.title {
            chunks.append(" title=\"\(title)\"")
        }

        switch node.link {
        case let .inline(link):
            chunks.append(" href=\"\(link)\"")
        case let .reference(ref):
            chunks.append(" href=\"\(ref)\"")
        }

        chunks.append(">")
        chunks.append(renderer.render(node.children))
        chunks.append("</a>")
        return chunks.joined()
    }
}

public struct CodeNodeHTMLRenderFragment: HTMLRenderFragment {
    public func render(
        _ node: AST.CodeNode,
        renderer: HTMLContentRenderer
    ) -> String? {
        var chunks = [String]()
        node.isBlock ? chunks.append("\n<pre>") : nil
        chunks.append("<code")
        chunks.append(">")
        chunks.append(renderer.render(node.children))
        chunks.append("</code>")
        node.isBlock ? chunks.append("</pre>\n") : nil
        return chunks.joined()
    }
}

public struct ListNodeHTMLRenderFragment: HTMLRenderFragment {
    public func render(
        _ node: AST.ListNode,
        renderer: HTMLContentRenderer
    ) -> String? {

        let tagName: String
        switch node.kind {
        case .bullet:
            tagName = "ul"
        case .ordered:
            tagName = "ol"
        }
        var chunks = [String]()
        if node.level == 0 {
            chunks.append("\n")
        }
        chunks.append(String(repeating: "  ", count: node.level))
        chunks.append("<\(tagName)>")
        for listElementNode in node.children where listElementNode is AST.ListElementNode {
            chunks.append("\n")
            chunks.append(String(repeating: "  ", count: node.level + 1))
            chunks.append("<li>")
            chunks.append(renderer.render(listElementNode.children))
            chunks.append("</li>")
        }
        chunks.append("\n")
        chunks.append(String(repeating: "  ", count: node.level))
        chunks.append("</\(tagName)>")
        if node.level == 0 {
            chunks.append("\n")
        }
        return chunks.joined()
    }
}

public struct NewLineNodeHTMLRenderFragment: HTMLRenderFragment {
    public func render(
        _ node: AST.NewLineNode,
        renderer: HTMLContentRenderer
    ) -> String? {
        return node.soft ? " " : "<br/>"
    }
}

public struct NothingNodeHTMLRenderFragment: HTMLRenderFragment {
    public func render(
        _ node: ASTNode,
        renderer: HTMLContentRenderer
    ) -> String? {
        return nil
    }
}

public struct HorizontalLineNodeHTMLRenderFragment: HTMLRenderFragment {
    public func render(
        _ node: AST.HorizontalLineNode,
        renderer: HTMLContentRenderer
    ) -> String? {
        return "\n<hr/>\n"
    }
}
