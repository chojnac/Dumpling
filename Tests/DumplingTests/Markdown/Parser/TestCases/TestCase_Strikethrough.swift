//
//  TestCase_Strikethrough.swift
//  DumplingTests
//
//  Created by Wojciech Chojnacki on 16/06/2019.
//  Copyright © 2019 Wojciech Chojnacki. All rights reserved.
//

@testable import Dumpling
import Foundation

extension TestCase {
    struct Strikethrough {
        static let case01 = TestCase(text: "~~lorem~~",
                                     parsed: "<p><s>lorem</s></p>")

        static let case02 = TestCase(text: "__~~lorem~~__",
                                     parsed: "<p><strong><s>lorem</s></strong></p>")

        static let case03 = TestCase(text: "~~__lorem ipsum__~~",
                                     parsed: "<p><s><strong>lorem␣ipsum</strong></s></p>")
    }
}
