//
//  AttributedStringRenderer+Context.swift
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
extension AttributedStringRenderer {
    public struct Context {
        public let theme: AttributedStringTheme
        public let parentAttributes: StringAttributesType
        public let path: [AttributedStringTheme.StyleKey]
        public let contentIdentLevel: Int // used for blockquote

        public init(theme: AttributedStringTheme) {
            self.theme = theme
            self.path = [.document]
            self.contentIdentLevel = 0
            self.parentAttributes = theme.style(forKey: .document).apply([:])
        }

        init(
            theme: AttributedStringTheme,
            parentAttributes: StringAttributesType,
            path: [AttributedStringTheme.StyleKey],
            contentIdentLevel: Int
        ) {
            self.theme = theme
            self.parentAttributes = parentAttributes
            self.path = path
            self.contentIdentLevel = contentIdentLevel
        }

        public func with(
            attributes: StringAttributesType,
            pathElement: AttributedStringTheme.StyleKey,
            ident: Bool = false
        ) -> Self {
            return .init(
                theme: theme,
                parentAttributes: attributes,
                path: path + [pathElement],
                contentIdentLevel: ident ? contentIdentLevel + 1 : contentIdentLevel
            )
        }

        public func attributes(forKey key: AttributedStringTheme.StyleKey) -> StringAttributesType {
            return theme.style(forKey: key).apply(parentAttributes)
        }
    }

}
#endif
