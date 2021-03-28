//
//  StringStyle.swift
//  Dumpling
//
//  Created by Wojciech Chojnacki on 21/03/2021.
//  Copyright © 2021 Dumpling. All rights reserved.
//

import Foundation

public typealias StyleId = String

#if canImport(UIKit)
import UIKit
public typealias Font = UIFont
public typealias Color = UIColor
public typealias FontDescriptor = UIFontDescriptor

extension UIFontDescriptor.SymbolicTraits {
    public static let bold = traitBold
    public static let italic = traitItalic
}
#elseif canImport(AppKit)
import AppKit
public typealias Font = NSFont
public typealias Color = NSColor
public typealias FontDescriptor = NSFontDescriptor
#endif

#if canImport(UIKit) || canImport(AppKit)

public typealias Style = (StringAttributesType) -> StringAttributesType

public struct StringStyle {
    let action: (StringAttributesType) -> StringAttributesType

    public init(_ action: @escaping (StringAttributesType) -> StringAttributesType) {
        self.action = action
    }
    public func apply(_ attr: StringAttributesType) -> StringAttributesType {
        action(attr)
    }
    public static let identity = StringStyle({ $0 })
    public static let zero = StringStyle({ _ in [:] })
    public static func just(_ attributes: StringAttributesType) -> StringStyle {
        StringStyle({ _ in attributes })
    }
}

public func compose(
    _ f1: StringStyle,
    _ f2: StringStyle
) -> StringStyle {
    return .init { attr in
        f2.apply(f1.apply(attr))
    }
}

public func compose(
    _ f1: StringStyle,
    _ f2: StringStyle,
    _ f3: StringStyle
) -> StringStyle {
    return .init { attr in
        f3.apply(f2.apply(f1.apply(attr)))
    }
}

#endif
