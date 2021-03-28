//
//  ListNodeRenderFragment.swift
//  Dumpling
//
//  Created by Wojciech Chojnacki on 22/03/2021.
//  Copyright © 2021 Dumpling. All rights reserved.
//

import Foundation
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

#if canImport(UIKit) || canImport(AppKit)
open class ListNodeRenderFragment: AttributedStringRenderFragment {
    public enum Indicator {
        case string(String)
        case number(String)
    }

    public init() {}
    
    public func render(
        _ node: AST.ListNode,
        context: AttributedStringRenderer.Context,
        renderer: AttributedStringContentRenderer
    ) -> NSAttributedString? {
        let attributes = context.theme.style(forKey: .document).apply([:])
        let childrenCount = node.children.count
        let attributedString = NSMutableAttributedString()

        for (idx, childNode) in node.children.enumerated() where childNode is AST.ListElementNode {
            let isLastItem = idx == childrenCount - 1

            let idn = self.indicator(node: node, position: idx)

            var attrs = attributes
            attrs[.paragraphStyle] = listParagraph(
                level: node.level,
                indicator: idn,
                attrs: attrs,
                isLastItem: isLastItem
            )
            let contentString = renderer.render(childNode.children, context: context.with(attributes: attrs))

            let listString = listItem(
                contentString,
                level: node.level,
                indicator: idn,
                attrs: attrs,
                isFistItem: idx == 0,
                isLastItem: isLastItem
            )
            attributedString.append(listString)
        }

        return attributedString
    }

    open func listParagraph(
        level: Int,
        indicator: Indicator,
        attrs: [NSAttributedString.Key: Any],
        isLastItem: Bool
    ) -> NSParagraphStyle {
        let initialHeadIdent: CGFloat = 0
        // horizontal offset between parent first character after indicator and nested indicator
        let nestedListOffset: CGFloat = 10
        let indentation2: CGFloat

        switch indicator {
        case let .string(value):
            indentation2 = value.size(withAttributes: attrs).width
        case let .number(value):
            indentation2 = value.size(withAttributes: attrs).width
        }

        let indentation: CGFloat = indentation2 + nestedListOffset

        let para = NSMutableParagraphStyle()
        para.alignment = .left
        para.defaultTabInterval = indentation
        para.tabStops = stride(from: 0, to: 3, by: 1).map{
            NSTextTab(
                textAlignment: .left,
                location: indentation * $0  + initialHeadIdent,
                options: [:]
            )
        }
        para.firstLineHeadIndent = initialHeadIdent
        para.headIndent = initialHeadIdent + indentation * CGFloat(level) + indentation2

        if let orgPara = attrs[.paragraphStyle] as? NSParagraphStyle, isLastItem {
            para.paragraphSpacing = orgPara.paragraphSpacing
        } else {

        }
        para.paragraphSpacing = 0
        return para
    }

    private func listItem(
        _ content: NSAttributedString,
        level: Int,
        indicator: Indicator,
        attrs: [NSAttributedString.Key: Any],
        isFistItem: Bool,
        isLastItem: Bool
    ) -> NSAttributedString {
        let attributes = attrs

        let string = NSMutableAttributedString()

        if isFistItem && level == 1 {
            string.append(NSAttributedString(string: "\n", attributes: attributes))
        }
        switch indicator {
        case  .string(let idn), .number(let idn):
            string.append(
                NSAttributedString(
                    string: String(repeating: "\t", count: level) + idn,
                    attributes: attributes
                )
            )
        }

        let mutableContent = NSMutableAttributedString(attributedString: content)
        mutableContent.addAttributes(attributes, range: NSRange(location: 0, length: mutableContent.length))
        string.append(mutableContent)
        if !isLastItem {
            string.append(NSAttributedString(string: "\n", attributes: attributes))
        }

        if isLastItem && level == 0 {
            string.append(NSAttributedString(string: "\n\n", attributes: attributes))
        }
        return string
    }

    open func indicator(node: AST.ListNode, position: Int) -> Indicator {
        switch node.kind {
        case .bullet:
            switch node.level {
            case 0:
                return .string("•  ")
            case 1:
                return .string("◦  ")
            case 3:
                return .string("◦  ")
            case 4:
                return .string("▪︎  ")
            case 5:
                return .string("▪︎  ")
            default:
                return .string("▪︎  ")
            }
        case .ordered(let start, _):
            let value = start + position
            return .number("\(value).  ")
        }
    }
}
#endif
