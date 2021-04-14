//
//  RenderFragment+Helpers.swift
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
extension AttributedStringRenderFragment {
    public func applyStyle(
        key: AttributedStringTheme.StyleKey,
        context: AttributedStringRenderer.Context,
        string: NSMutableAttributedString
    ) {
        let attributes = context.attributes(forKey: key)
        string.addAttributes(attributes, range: NSRange(location: 0, length: string.length))
    }
    
    public func applyStyle(
        key: AttributedStringTheme.StyleKey,
        context: AttributedStringRenderer.Context,
        string: NSAttributedString
    ) -> NSAttributedString {
        let attributes = context.attributes(forKey: key)
        let result = NSMutableAttributedString(attributedString: string)
        result.addAttributes(attributes, range: NSRange(location: 0, length: string.length))
        return result
    }

    public func makeContentIdent(
        context: AttributedStringRenderer.Context,
        attributes: inout StringAttributesType
    ) {
        let level = context.contentIdentLevel
        guard level > 0 else { return }

        let value = CGFloat(level) * CGFloat(context.theme.contentIdentSize)

        guard let someParagraph = attributes[.paragraphStyle] as? NSParagraphStyle
        else {
            let paragraph = NSMutableParagraphStyle()
            paragraph.firstLineHeadIndent = value
            paragraph.headIndent = value
            attributes[.paragraphStyle] = paragraph
            return
        }

        let paragraph = NSMutableParagraphStyle()
        paragraph.setParagraphStyle(someParagraph)
        paragraph.firstLineHeadIndent += value
        paragraph.headIndent += value
        attributes[.paragraphStyle] = paragraph

    }
}
#endif
