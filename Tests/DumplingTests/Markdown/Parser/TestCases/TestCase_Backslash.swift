//
//  TestCase_Backslash.swift
//  DumplingTests
//
//  Created by Wojciech Chojnacki on 26/01/2019.
//  Copyright © 2019 Wojciech Chojnacki. All rights reserved.
//

@testable import Dumpling
import Foundation

extension TestCase {
    struct Backslash {
        static let case01 = TestCase(text: "\\***lorem***",
                                     parsed: "<p>*<strong>lorem</strong>*</p>")

        static let case02 = TestCase(text: "\\lorem",
                                     parsed: "<p>\\lorem</p>")

        static let case03 = TestCase(text: #"\\*lorem*"#,
                                     parsed: #"<p>\<em>lorem</em></p>"#)

        static let case04 = TestCase(text: "\\\n*lorem*",
                                     parsed: #"<p>\⌟<em>lorem</em></p>"#)
    }
}
