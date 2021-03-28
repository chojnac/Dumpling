//
//  TestCase_List.swift
//  DumplingTests
//
//  Created by Wojciech Chojnacki on 13/12/2019.
//  Copyright © 2019 Wojciech Chojnacki. All rights reserved.
//

import Foundation

// swiftlint:disable line_length
extension TestCase {
    struct List {
        static let case01 = TestCase(
            text: " * Lorem \n * Ipsum",
            parsed: "<ul l=0><li>Lorem␣</li><li>Ipsum</li></ul>"
        )

        static let case02 = TestCase(
            text: """
* Lorem
  * Sub 1
    * Sub 2
* Ipsum
""",
            parsed: "<ul l=0><li>Lorem<ul l=1><li>Sub␣1<ul l=2><li>Sub␣2</li></ul></li></ul></li><li>Ipsum</li></ul>"
        )

        static let case03 = TestCase(
            text: " * Lorem **bold \n message** \n * Ipsum *italic \n message* \n\n Paragraph",
            parsed: "<ul l=0><li>Lorem␣<strong>bold␣⏎␣message</strong>␣</li><li>Ipsum␣<em>italic␣⏎␣message</em>␣</li></ul><p>␣Paragraph</p>"
        )
        static let case04 = TestCase(
            text: """
* Status: **Implemented (Swift 5.1)**
* Amendment status: **Implemented (Swift 5.1)**
* Implementation: [apple/swift#21845](https://github.com/apple/swift/pull/21845)

## Introduction
""",
            parsed: "<ul l=0><li>Status:␣<strong>Implemented␣(Swift␣5.1)</strong></li><li>Amendment␣status:␣<strong>Implemented␣(Swift␣5.1)</strong></li><li>Implementation:␣<link uri=\"https://github.com/apple/swift/pull/21845\">apple/swift#21845</link></li></ul><h2>Introduction</h2>"
        )

        static let case05 = TestCase(
            text: """
*   [Overview](#overview)
    *   [Philosophy](#philosophy)
    *   [Inline HTML](#html)
    *   [Automatic](#autoescape)
*   [Block Elements](#block)
    *   [Paragraphs](#p)
    *   [Headers](#header)
""",
            parsed: """
<ul l=0><li><link ref="#overview">Overview</link><ul l=1><li><link ref="#philosophy">Philosophy</link></li><li><link ref="#html">Inline HTML</link></li><li><link ref="#autoescape">Automatic</link></li></ul></li><li><link ref="#block">Block Elements</link><ul l=1><li><link ref="#p">Paragraphs</link></li><li><link ref="#header">Headers</link></li></ul></li></ul>
"""
        )

        static let case06 = TestCase(
            text: """
1. Lorem
  * Sub 1
    * Sub 2
1. Ipsum
""",
            parsed: "<ol l=0 start=1><li>Lorem<ul l=1><li>Sub␣1<ul l=2><li>Sub␣2</li></ul></li></ul></li><li>Ipsum</li></ol>"
        )

        static let case07 = TestCase(
            text: """
1. Lorem
* ipsum
1. dolor
""",
            parsed: "<ol l=0 start=1><li>Lorem</li></ol><ul l=0><li>ipsum</li></ul><ol l=0 start=1><li>dolor</li></ol>"
        )

        static let case08 = TestCase(
            text: """
1. Lorem
* ipsum
* dolor
1. sit amet
""",
            parsed: "<ol l=0 start=1><li>Lorem</li></ol><ul l=0><li>ipsum</li><li>dolor</li></ul><ol l=0 start=1><li>sit␣amet</li></ol>"
        )

        static let case09 = TestCase(
            text: """
* Lorem
  1. ipsum
  2. dolor
* sit amet
""",
            parsed: "<ul l=0><li>Lorem<ol l=1 start=1><li>ipsum</li><li>dolor</li></ol></li><li>sit␣amet</li></ul>"
        )

        static let case10 = TestCase(
            text: """
1. Lorem
1) Ipsum
""",
            parsed: "<ol l=0 start=1><li>Lorem</li></ol><ol l=0 start=1><li>Ipsum</li></ol>"
        )
    }
}
