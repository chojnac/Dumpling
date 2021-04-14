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

    /// How many points we ident paragraph for a level 
    public var contentIdentSize: CGFloat = 20
    
    public required init(baseFont: Font, color: Color) {
        styles = [
            .document: compose(
                .font(baseFont),
                .foregroundColor(color),
                .defaultParagraph()
            ),
        ]
        
        addStyle(contentOf: [
            (key: .strong, value: StringStyle.traits([.bold])),
            (key: .em, value: StringStyle.traits([.italic])),
            (key: .code, value: Helpers.inlineCodeStyle()),
            (key: .codeBlock, value: compose(Helpers.inlineCodeStyle(), Helpers.blockCodeStyle())),
            (key: .hr, value: StringStyle.strikethrough(style: .single, color: .gray))
        ])

        #if canImport(AppKit)
        addStyle(contentOf: [
            (key: .h1, value: Helpers.headerStyle(font: .boldSystemFont(ofSize: 26))),
            (key: .h2, value: Helpers.headerStyle(font: .boldSystemFont(ofSize: 22))),
            (key: .h3, value: Helpers.headerStyle(font: .boldSystemFont(ofSize: 17))),
            (key: .h4, value: Helpers.headerStyle(font: .boldSystemFont(ofSize: 15))),
            (key: .h5, value: Helpers.headerStyle(font: .boldSystemFont(ofSize: 13))),
            (key: .h6, value: Helpers.headerStyle(font: .boldSystemFont(ofSize: 13))),
        ])
        #else
        addStyle(contentOf: [
            (key: .h1, value: Helpers.headerStyle(font: .boldSystemFont(ofSize: 34))),
            (key: .h2, value: Helpers.headerStyle(forTextStyle: .title1)),
            (key: .h3, value: Helpers.headerStyle(forTextStyle: .title2)),
            (key: .h4, value: Helpers.headerStyle(forTextStyle: .title3)),
            (key: .h5, value: Helpers.headerStyle(forTextStyle: .headline)),
            (key: .h6, value: Helpers.headerStyle(forTextStyle: .headline)),
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

    public static let link = Self("link")

    public static let list = Self("list")
    public static let blockquote = Self("blockquote")

    public static let code = Self("code")
    public static let codeBlock = Self("codeBlock")

    public static let h1 = Self("h1")
    public static let h2 = Self("h2")
    public static let h3 = Self("h3")
    public static let h4 = Self("h4")
    public static let h5 = Self("h5")
    public static let h6 = Self("h6")

    public static let hr = Self("hr")
}
#endif
