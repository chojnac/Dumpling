//
//  TestCase_Code_Span.swift
//  DumplingTests
//
//  Created by Wojciech Chojnacki on 18/02/2019.
//  Copyright © 2019 Wojciech Chojnacki. All rights reserved.
//

@testable import Dumpling
import Foundation

extension TestCase {
    struct CodeSpan {
        static let case01 = TestCase(text: "Use the `printf()` function.",
                                     parsed: "<p>Use␣the␣<code>printf()</code>␣function.</p>")

        static let case02 = TestCase(text: "``There is a literal backtick (`) here.``",
                                     parsed: "<p><code>There is a literal backtick (`) here.</code></p>")

        static let case03 = TestCase(text: "A single backtick in a code span: ``  `  ``",
                                     parsed: "<p>A␣single␣backtick␣in␣a␣code␣span:␣<code>`</code></p>")

        static let case04 = TestCase(text: "`foo   bar\n  baz`",
                                     parsed: "<p><code>foo bar baz</code></p>")

        static let case05 = TestCase(text: "`` foo   bar\n\n  baz   ``",
                                     parsed: "<p>``␣foo␣bar</p><p>baz␣``</p>")

        static let case06 = TestCase(text: "*foo`*`",
                                     parsed: "<p>*foo<code>*</code></p>")

        static let case07 = TestCase(text: #"`\*foo*\`"#,
                                     parsed: #"<p><code>\*foo*\</code></p>"#)

        static let case08 = TestCase(text: "`` foo   bar  baz   ``",
                                     parsed: "<p><code>foo bar baz</code></p>")

        static let case09 = TestCase(text: "**message `lorem` ipsum**",
                                     parsed: "<p><strong>message␣<code>lorem</code>␣ipsum</strong></p>")
    }
}
