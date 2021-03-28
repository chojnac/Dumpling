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

        public init(theme: AttributedStringTheme) {
            self.theme = theme
            self.parentAttributes = theme.style(forKey: .document).apply([:])
        }

        init(theme: AttributedStringTheme, parentAttributes: StringAttributesType) {
            self.theme = theme
            self.parentAttributes = parentAttributes
        }

        public func with(attributes: StringAttributesType) -> Self {
            return .init(theme: theme, parentAttributes: attributes)
        }

        public func attributes(forKey key: AttributedStringTheme.StyleKey) -> StringAttributesType {
            return theme.style(forKey: key).apply(parentAttributes)
        }
    }

}
#endif
