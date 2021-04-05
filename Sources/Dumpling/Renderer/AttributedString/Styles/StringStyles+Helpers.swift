//
//  StringStyle.swift
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

extension StringStyle {
    
    public static func font(_ font: Font) -> StringStyle {
        .init { attr in
            var result = attr
            result[.font] = font
            return result
        }
    }
    #if canImport(AppKit)
    public typealias TraitsType = NSFontTraitMask
    #else
    public typealias TraitsType = [FontDescriptor.SymbolicTraits]
    #endif
    public static func traits(_ traits: TraitsType) -> StringStyle {
        .init { attr in
            guard let baseFont = attr[.font] as? Font else {
                return attr
            }
            
            var result = attr
            #if canImport(AppKit)
            result[.font] = NSFontManager().convert(baseFont, toHaveTrait: traits)
            #else
            guard let descriptor = baseFont.fontDescriptor
                    .withSymbolicTraits(UIFontDescriptor.SymbolicTraits(traits)) else {
                return attr
            }
            
            result[.font] = UIFont(descriptor: descriptor, size: baseFont.pointSize)
            #endif
            
            return result
        }
    }
    
    public static func backgroundColor(_ color: Color) -> StringStyle {
        .init { attr in
            var result = attr
            result[.backgroundColor] = color
            return result
        }
    }
    
    public static func foregroundColor(_ color: Color) -> StringStyle {
        .init { attr in
            var result = attr
            result[.foregroundColor] = color
            return result
        }
    }
    
    public static func fontSize(_ size: CGFloat) -> StringStyle {
        .init { attr in
            guard let baseFont = attr[.font] as? Font else {
                return attr
            }
            
            let desc = baseFont.fontDescriptor
            let font = Font(descriptor: desc, size: size)
            var result = attr
            result[.font] = font
            return result
        }
    }
    
    public static func defaultParagraph(
        paragraphSpacing: CGFloat = 0,
        headIndent: CGFloat = 0,
        firstLineHeadIndent: CGFloat = 0
    ) -> StringStyle {
        .init {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.firstLineHeadIndent = firstLineHeadIndent
            paragraphStyle.headIndent = headIndent
            paragraphStyle.paragraphSpacing = paragraphSpacing
            
            var attributes = $0
            attributes[.paragraphStyle] = paragraphStyle
            return attributes
        }
    }

    public static func strikethrough(
        style: NSUnderlineStyle?,
        color: Color?
    ) -> StringStyle {
        .init {
            var attributes = $0
            if let value = style {
                attributes[.strikethroughStyle] = value.rawValue
            }
            if let value = color {
                attributes[.strikethroughColor] = value
            }
            return attributes
        }
    }
}
#endif
