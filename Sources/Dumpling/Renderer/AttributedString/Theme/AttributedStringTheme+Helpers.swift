//
//  AttributedStringTheme+Helpers.swift
//  Dumpling
//
//  Created by Wojciech Chojnacki on 05/04/2021.
//  Copyright © 2021 Dumpling. All rights reserved.
//

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

#if canImport(UIKit) || canImport(AppKit)
extension AttributedStringTheme {
    public struct Helpers {
        static public func headerStyle(font: Font, paragraphSpacing: CGFloat = 20.0) -> StringStyle {
            return compose(
                .font(font),
                .defaultParagraph(paragraphSpacing: paragraphSpacing)
            )
        }
        
        #if canImport(UIKit)
        static public func headerStyle(
            forTextStyle style: UIFont.TextStyle,
            paragraphSpacing: CGFloat = 20.0
        ) -> StringStyle {
            return compose(
                .font(.preferredFont(forTextStyle: style)),
                .defaultParagraph(paragraphSpacing: paragraphSpacing)
            )
        }
        #endif

        static public func inlineCodeStyle() -> StringStyle {
            #if canImport(AppKit)
            let monospaceFont = NSFont(name: "Menlo-Regular", size: 13)!
            return compose(
                StringStyle.font(monospaceFont),
                StringStyle.foregroundColor(Color(red: 0.90, green: 0.20, blue: 0.40, alpha: 1.0)),
                StringStyle.backgroundColor(Color(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0))
            )
            #else
            return compose(
                StringStyle.font(.monospacedDigitSystemFont(ofSize: 17, weight: .regular)),
                StringStyle.foregroundColor(Color(red: 0.90, green: 0.20, blue: 0.40, alpha: 1.0)),
                StringStyle.backgroundColor(Color(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0))
            )
            #endif
        }
        static public func blockCodeStyle() -> StringStyle {
            StringStyle {
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.firstLineHeadIndent = 0
                paragraphStyle.headIndent = 0
                paragraphStyle.paragraphSpacing = 0
                paragraphStyle.paragraphSpacingBefore = 0
                var attributes = $0
                attributes[.paragraphStyle] = paragraphStyle
                return attributes
            }
        }
    }
}
#endif
