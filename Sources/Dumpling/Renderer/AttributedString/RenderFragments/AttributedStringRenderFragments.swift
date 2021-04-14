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
            context: context.with(
                attributes: attributes,
                pathElement: key
            )
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
        var attributes = context.attributes(forKey: key)
        makeContentIdent(context: context, attributes: &attributes)
        let string = NSMutableAttributedString()
        string.append(
            renderer.render(
                node.children,
                context: context.with(
                    attributes: attributes,
                    pathElement: key
                )
            )
        )
        string.append(NSAttributedString(string: "\n", attributes: attributes))
        string.addAttributes(attributes, range: NSRange(location: 0, length: string.length))
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
        var attributes = context.attributes(forKey: .p)
        let string = NSMutableAttributedString()
        makeContentIdent(context: context, attributes: &attributes)
        string.append(
            renderer.render(
                node.children,
                context: context.with(
                    attributes: attributes,
                    pathElement: .p
                )
            )
        )
        string.append(NSAttributedString(string: "\n\n", attributes: attributes))
        return string
    }
}

public struct NewLineNodeRenderFragment: AttributedStringRenderFragment {
    public func render(
        _ node: AST.NewLineNode,
        context: AttributedStringRenderer.Context,
        renderer: AttributedStringContentRenderer
    ) -> NSAttributedString? {
        let attributes = context.parentAttributes
        return NSAttributedString(string: node.soft ? " " : "\n", attributes: attributes)
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
