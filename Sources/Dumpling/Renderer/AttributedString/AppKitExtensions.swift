//
//  AppKitExtensions.swift
//  Dumpling
//
//  Created by Wojciech Chojnacki on 24/03/2021.
//  Copyright © 2021 Dumpling. All rights reserved.
//

import Foundation
#if canImport(AppKit)
import AppKit

extension NSFontTraitMask {
    public static let italic = italicFontMask
    public static let bold = boldFontMask
}
#endif
