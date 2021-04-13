//
//  TestCase_Header.swift
//  DumplingTests
//
//  Created by Wojciech Chojnacki on 09/04/2021.
//  Copyright © 2021 Dumpling. All rights reserved.
//

@testable import Dumpling
import Foundation

// swiftlint:disable line_length
extension TestCase {
    struct Header {
        static let case01 = TestCase(text: "# Header 1 ",
                                     parsed: "<h1>Header␣1␣</h1>")

        static let case02 = TestCase(text: " # Header 1 \n\n test",
                                     parsed: "<h1>Header␣1</h1><p>␣test</p>")

        static let case03 = TestCase(text: "  \n\n # Header 1 \n test",
                                     parsed: "<h1>Header␣1</h1><p>␣test</p>")

        static let case04 = TestCase(text: """

        ## Span Elements

        ### Links

        Markdown supports two style of links: *inline* and *reference*.

        In both styles, the link text is delimited by [square brackets].

""",
                                     parsed: "<h2>Span␣Elements</h2><h3>Links</h3><p>␣Markdown␣supports␣two␣style␣of␣links:␣<em>inline</em>␣and␣<em>reference</em>.</p><p>In␣both␣styles,␣the␣link␣text␣is␣delimited␣by␣[square␣brackets].</p>")
    }
}
