//
//  BaseTheme.swift
//  Dumpling
//
//  Created by Wojciech Chojnacki on 12/01/2019.
//  Copyright © 2019 Wojciech Chojnacki. All rights reserved.
//

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

#if canImport(UIKit) || canImport(AppKit)

open class AttributedStringTheme {
    public struct StyleKey: Equatable, Hashable, CustomDebugStringConvertible {
        private let identifier: String

        public var debugDescription: String {
            "StyleKey(\(identifier))"
        }

        public init(_ identifier: String) {
            self.identifier = identifier
        }
    }

    private var styles: [StyleKey: StringStyle]

    public required init(baseFont: Font, color: Color) {
        styles = [
            .document: compose(.font(baseFont), .foregroundColor(color), .defaultParagraph()),
        ]
        #if canImport(AppKit)
        let monospaceFont = NSFont(name: "Menlo-Regular", size: 13)!
        let inlineCodeStyle = compose(
            StringStyle.font(monospaceFont),
            StringStyle.foregroundColor(Color(red: 0.90, green: 0.20, blue: 0.40, alpha: 1.0)),
            StringStyle.backgroundColor(Color(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0))
        )
        #else
        let inlineCodeStyle = compose(
            StringStyle.font(.monospacedDigitSystemFont(ofSize: 17, weight: .regular)),
            StringStyle.foregroundColor(Color(red: 0.90, green: 0.20, blue: 0.40, alpha: 1.0)),
            StringStyle.backgroundColor(Color(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0))
        )
        #endif
        
        let blockCodeParagraph = StringStyle {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.firstLineHeadIndent = 0
            paragraphStyle.headIndent = 0
            paragraphStyle.paragraphSpacing = 0
            paragraphStyle.paragraphSpacingBefore = 0
            var attributes = $0
            attributes[.paragraphStyle] = paragraphStyle
            return attributes
        }

        addStyle(contentOf: [
            (key: StyleKey.strong, value: StringStyle.traits([.bold])),
            (key: StyleKey.em, value: StringStyle.traits([.italic])),
            (key: StyleKey.code, value: inlineCodeStyle),
            (key: StyleKey.codeBlock, value: compose(inlineCodeStyle, blockCodeParagraph)),
        ])
        #if canImport(AppKit)
        addStyle(contentOf: [
            (key: StyleKey.h1, value: StringStyle.font(.boldSystemFont(ofSize: 26))),
            (key: StyleKey.h2, value: StringStyle.font(.boldSystemFont(ofSize: 22))),
            (key: StyleKey.h3, value: StringStyle.font(.boldSystemFont(ofSize: 17))),
            (key: StyleKey.h4, value: StringStyle.font(.boldSystemFont(ofSize: 15))),
            (key: StyleKey.h5, value: StringStyle.font(.boldSystemFont(ofSize: 13))),
            (key: StyleKey.h6, value: StringStyle.font(.boldSystemFont(ofSize: 13))),
        ])
        #else
        addStyle(contentOf: [
            (key: StyleKey.h1, value: StringStyle.font(.boldSystemFont(ofSize: 34))),
            (key: StyleKey.h2, value: StringStyle.font(.preferredFont(forTextStyle: .title1))),
            (key: StyleKey.h3, value: StringStyle.font(.preferredFont(forTextStyle: .title2))),
            (key: StyleKey.h4, value: StringStyle.font(.preferredFont(forTextStyle: .title3))),
            (key: StyleKey.h5, value: StringStyle.font(.preferredFont(forTextStyle: .headline))),
            (key: StyleKey.h6, value: StringStyle.font(.preferredFont(forTextStyle: .headline))),
        ])
        #endif
    }

    public func addStyle(forKey key: StyleKey, style: StringStyle) {
        styles[key] = style
    }

    public func addStyle(contentOf content: [(key: StyleKey, value: StringStyle)]) {
        content.forEach(addStyle(forKey:style:))
    }

    public func style(forKey key: StyleKey) -> StringStyle {
        return styles[key] ?? .identity
    }
}

extension AttributedStringTheme.StyleKey {
    public static let document = Self("document")

    public static let p = Self("p")

    public static let em = Self("em")
    public static let strong = Self("strong")
    public static let s = Self("s")

    public static let code = Self("code")
    public static let codeBlock = Self("codeBlock")

    public static let h1 = Self("h1")
    public static let h2 = Self("h2")
    public static let h3 = Self("h3")
    public static let h4 = Self("h4")
    public static let h5 = Self("h5")
    public static let h6 = Self("h6")
}
#endif
