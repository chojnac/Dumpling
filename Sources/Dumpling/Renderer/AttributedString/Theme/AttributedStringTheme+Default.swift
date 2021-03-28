//
//  BaseTheme+Default.swift
//  Dumpling
//
//  Created by Wojciech Chojnacki on 21/03/2021.
//  Copyright © 2021 Dumpling. All rights reserved.
//

import Foundation

#if canImport(UIKit)
extension AttributedStringTheme {
    public static let `default`: AttributedStringTheme = .init(
        baseFont: .preferredFont(forTextStyle: .body),
        color: .black
    )
}
#elseif canImport(AppKit)
import AppKit

extension AttributedStringTheme {
    public static let `default`: AttributedStringTheme = .init(
        baseFont: .systemFont(ofSize: 13),
        color: .black
    )
}
#endif
