//
//  TestCase_Link.swift
//  DumplingTests
//
//  Created by Wojciech Chojnacki on 30/06/2019.
//  Copyright © 2019 Wojciech Chojnacki. All rights reserved.
//

@testable import Dumpling
import Foundation

extension TestCase {
    struct Link {
        static let case01 = TestCase(text: #"[link](/uri)"#,
                                     parsed: #"<p><link uri="/uri">link</link></p>"#)

        static let case02a = TestCase(text: #"[link](/uri "title")"#,
                                      parsed: #"<p><link title="title" uri="/uri">link</link></p>"#)

        static let case02b = TestCase(text: #"[link](/uri 'title')"#,
                                      parsed: #"<p><link title="title" uri="/uri">link</link></p>"#)

        static let case02c = TestCase(text: #"[link](/uri (title))"#,
                                      parsed: #"<p><link title="title" uri="/uri">link</link></p>"#)

        static let case03 = TestCase(text: #"[link]()"#,
                                     parsed: #"<p><link uri="">link</link></p>"#)

        static let case04 = TestCase(text: #"[link](<>)"#,
                                     parsed: #"<p><link uri="">link</link></p>"#)

        static let case05 = TestCase(text: #"[link **lorem**](/uri)"#,
        parsed: #"<p><link uri="/uri">link <em>lorem</em></link></p>"#)

        static let case06 = TestCase(text: #"[link](</my uri>)"#,
                                     parsed: #"<p><link uri="/my uri">link</link></p>"#)

        static let case07 = TestCase(text: "[link](foo\nbar)",
                                     parsed: "<p>[link](foo⌟bar)</p>")

        static let case08 = TestCase(text: #"[link](\(foo\))"#,
                                     parsed: #"<p><link uri="(foo)">link</link></p>"#)

        static let case09 = TestCase(text: #"[link [foo [bar]]](/uri)"#,
                                     parsed: #"<p><link uri="/uri">link [foo [bar]]</link></p>"#)
    }
}
