//
//  RenderFragments.swift
//  Dumpling
//
//  Created by Wojciech Chojnacki on 23/03/2021.
//  Copyright © 2021 Dumpling. All rights reserved.
//

import Foundation

// MARK: -

#if canImport(UIKit) || canImport(AppKit)
public struct StyleNodeRenderFragment: AttributedStringRenderFragment {
    public func render(
        _ node: AST.StyleNode,
        context: AttributedStringRenderer.Context,
        renderer: AttributedStringContentRenderer
    ) -> NSAttributedString? {
        let key = AttributedStringTheme.StyleKey(node.id)
        let attributes = context.attributes(forKey: key)
        let string = renderer.render(
            node.children,
            context: context.with(attributes: attributes)
        )
        return applyStyle(key: key, context: context, string: string)
    }
}

public struct HeaderNodeRenderFragment: AttributedStringRenderFragment {
    public func render(
        _ node: AST.HeaderNode,
        context: AttributedStringRenderer.Context,
        renderer: AttributedStringContentRenderer
    ) -> NSAttributedString? {
        let key = AttributedStringTheme.StyleKey("h\(node.size)")
        let attributes = context.attributes(forKey: key)
        let string = NSMutableAttributedString()
        string.append(renderer.render(node.children, context: context.with(attributes: attributes)))
        string.append(NSAttributedString(string: "\n", attributes: attributes))
        applyStyle(key: key, context: context, string: string)
        return string
    }
}

public struct TextNodeRenderFragment: AttributedStringRenderFragment {
    public func render(
        _ node: AST.TextNode,
        context: AttributedStringRenderer.Context,
        renderer: AttributedStringContentRenderer
    ) -> NSAttributedString? {
        return NSAttributedString(string: node.text, attributes: context.parentAttributes)
    }
}

public struct SpaceNodeRenderFragment: AttributedStringRenderFragment {
    public func render(
        _ node: AST.SpaceNode,
        context: AttributedStringRenderer.Context,
        renderer: AttributedStringContentRenderer
    ) -> NSAttributedString? {
        return NSAttributedString(string: " ", attributes: context.parentAttributes)
    }
}

public struct ParagraphNodeRenderFragment: AttributedStringRenderFragment {
    public func render(
        _ node: AST.ParagraphNode,
        context: AttributedStringRenderer.Context,
        renderer: AttributedStringContentRenderer
    ) -> NSAttributedString? {
        let key = AttributedStringTheme.StyleKey.p
        let attributes = context.attributes(forKey: key)
        let string = NSMutableAttributedString()
        string.append(renderer.render(node.children, context: context.with(attributes: attributes)))
        string.append(NSAttributedString(string: "\n", attributes: attributes))
        return string
    }
}

public struct NothingNodeRenderFragment: AttributedStringRenderFragment {
    public func render(
        _ node: ASTNode,
        context: AttributedStringRenderer.Context,
        renderer: AttributedStringContentRenderer
    ) -> NSAttributedString? {
        return nil
    }
}
#endif
