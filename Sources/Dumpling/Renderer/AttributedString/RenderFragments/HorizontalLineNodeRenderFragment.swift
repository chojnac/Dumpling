//
//  HorizontalLineNodeRenderFragment.swift
//  Dumpling
//
//  Created by Wojciech Chojnacki on 05/04/2021.
//  Copyright © 2021 Dumpling. All rights reserved.
//

import Foundation
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

#if canImport(UIKit) || canImport(AppKit)
public struct HorizontalLineNodeRenderFragment: AttributedStringRenderFragment {
    public func render(
        _ node: AST.HorizontalLineNode,
        context: AttributedStringRenderer.Context,
        renderer: AttributedStringContentRenderer
    ) -> NSAttributedString? {
        let attributes = context.theme
            .style(forKey: .hr)
            .apply([ // default values
                    .strikethroughStyle: NSUnderlineStyle.single,
                    .strikethroughColor: Color.gray
            ])

        return NSAttributedString(
            string: "\u{00A0} \u{0009} \u{00A0}\n\n",
            attributes: attributes
        )
    }
}
#endif
