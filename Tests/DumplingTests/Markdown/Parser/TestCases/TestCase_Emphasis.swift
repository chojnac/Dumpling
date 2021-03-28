//
//  TestCase_Emphasis.swift
//  DumplingTests
//
//  Created by Wojciech Chojnacki on 30/11/2019.
//  Copyright © 2019 Wojciech Chojnacki. All rights reserved.
//

import Dumpling
import Foundation

extension TestCase {
    struct Emphasis {
        static let case01 = TestCase(text: "**lorem**",
                                     parsed: "<p><strong>lorem</strong></p>")

        static let case02 = TestCase(text: "***lorem***",
                                     parsed: "<p><strong><em>lorem</em></strong></p>")

        static let case03 = TestCase(text: "___lorem___",
                                     parsed: "<p><strong><em>lorem</em></strong></p>")

        static let case04 = TestCase(text: "**_lorem_**",
                                     parsed: "<p><strong><em>lorem</em></strong></p>")

        static let case05 = TestCase(text: "***lo**ip*",
                                     parsed: "<p><em><strong>lo</strong>ip</em></p>")

        static let case06 = TestCase(text: "***lorem* ipsum**",
                                     parsed: "<p><strong><em>lorem</em>␣ipsum</strong></p>")

        static let case07 = TestCase(text: "****lorem****",
                                     parsed: "<p><strong><strong>lorem</strong></strong></p>")

        static let case08 = TestCase(text: "*********lorem*********",
                                     parsed: "<p><strong><strong><strong><strong><em>lorem</em></strong></strong></strong></strong></p>")

        static let case09 = TestCase(text: "Lorem ***ipsum*** *dolor* sit",
                                     parsed: "<p>Lorem␣<strong><em>ipsum</em></strong>␣<em>dolor</em>␣sit</p>")

        static let case10 = TestCase(text: "*lorem*",
                                     parsed: "<p><em>lorem</em></p>")

        static let case11 = TestCase(text: "**\ntest",
                                     parsed: "<p>**⏎test</p>")


        static let case12 = TestCase(text: "*lorem\n*",
                                     parsed: #"<p>*lorem⏎*</p>"#)
    }
}
