//
//  TestCase_NewLine.swift
//  DumplingTests
//
//  Created by Wojciech Chojnacki on 13/04/2021.
//  Copyright © 2021 Dumpling. All rights reserved.
//

@testable import Dumpling
import Foundation

extension TestCase {
    struct NewLine {
        static let case01 = TestCase(text: "foo\nbar",
                                     parsed: "<p>foo⌟bar</p>")

        static let case02 = TestCase(text: "foo \nbar",
                                     parsed: "<p>foo⌟bar</p>")

        static let case03 = TestCase(text: "foo  \n bar",
                                     parsed: #"<p>foo⏎␣bar</p>"#)

        static let case04 = TestCase(text: "\nfoo",
                                     parsed: #"<p>foo</p>"#)
    }
}
