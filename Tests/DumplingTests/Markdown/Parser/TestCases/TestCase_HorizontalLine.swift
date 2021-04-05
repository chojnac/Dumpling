//
//  TestCase_HorizontalLine.swift
//  Dumpling
//
//  Created by Wojciech Chojnacki on 05/04/2021.
//  Copyright © 2021 Dumpling. All rights reserved.
//

@testable import Dumpling
import Foundation

extension TestCase {
    struct HorizontalLine {
        static let case01 = TestCase(text: "***\n---\n___",
                                     parsed: "<hr><hr><hr>")

        static let case02 = TestCase(text: "+++",
                                     parsed: "<p>+++</p>")

        static let case03 = TestCase(text: "**\n--\n__",
                                     parsed: "<p>**⏎--⏎__</p>")

        static let case04 = TestCase(text: " ***\n  ***\n   ***",
                                     parsed: "<hr><hr><hr>")

        static let case05 = TestCase(text: "    ***",
                                     parsed: "<p>␣***</p>")

        static let case06 = TestCase(text: "_____________________________________",
                                     parsed: "<hr>")

        static let case07 = TestCase(text: " - - -",
                                     parsed: "<hr>")

        static let case08 = TestCase(text: " **  * ** * ** * **",
                                     parsed: "<hr>")

        static let case09 = TestCase(text: "-     -      -      -",
                                     parsed: "<hr>")

        static let case10 = TestCase(text: "-     -      -      -",
                                     parsed: "<hr>")

        static let case11 = TestCase(text: "- - - -    ",
                                     parsed: "<hr>")

        static let case12 = TestCase(text: "_ _ _ _ a",
                                     parsed: "<p>_␣_␣_␣_␣a</p>")

        static let case13 = TestCase(text: " *-*",
                                     parsed: "<p>␣<em>-</em></p>")

        static let case14 = TestCase(text: "Foo\n***\nbar",
                                     parsed: "<p>Foo⏎</p><hr><p>bar</p>")
    }
}
