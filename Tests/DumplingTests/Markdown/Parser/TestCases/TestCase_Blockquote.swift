//
//  TestCase_Blockquote.swift
//  Dumpling
//
//  Created by Wojciech Chojnacki on 06/04/2021.
//  Copyright © 2021 Dumpling. All rights reserved.
//

@testable import Dumpling
import Foundation

extension TestCase {
    struct Blockquote {
        static let case01 = TestCase(text: "> # Foo\n> bar\n> baz",
                                     parsed: #"<quote><h1>Foo</h1><p>bar⌟baz</p></quote>"#)

        static let case02 = TestCase(text: "># Foo\n>bar\n> baz",
                                      parsed: #"<quote><h1>Foo</h1><p>bar⌟baz</p></quote>"#)

        static let case03 = TestCase(text: "   ># Foo\n   >bar\n > baz",
                                      parsed: #"<quote><h1>Foo</h1><p>bar⌟baz</p></quote>"#)

        static let case04 = TestCase(text: "> # Foo\n> bar\nbaz",
                                      parsed: #"<quote><h1>Foo</h1><p>bar⌟baz</p></quote>"#)

        static let case05 = TestCase(text: "> bar\nbaz\n> foo",
                                     parsed: #"<quote><p>bar⌟baz⌟foo</p></quote>"#)

        static let case06 = TestCase(text: "> foo\n---",
                                     parsed: #"<quote><p>foo⌟</p></quote><hr>"#)

        static let case07 = TestCase(text: #">  "#,
                                     parsed: #"<quote></quote>"#)

        static let case08 = TestCase(text: "> foo \n\n> bar",
                                     parsed: #"<quote><p>foo␣</p></quote><quote><p>bar</p></quote>"#)

        static let case09 = TestCase(text: "> foo \n>\n> bar",
                                     parsed: #"<quote><p>foo</p><p>bar</p></quote>"#)

        static let case10 = TestCase(text: "foo\n> bar",
                                     parsed: #"<p>foo⌟</p><quote><p>bar</p></quote>"#)

        static let case11 = TestCase(text: "> > > foo\nbar",
                                     parsed: #"<quote><quote><quote><p>foo⌟bar</p></quote></quote></quote>"#)

        static let case12 = TestCase(text: "> foo\n>> bar\n> baz",
                                     parsed: #"<quote><p>foo⌟</p><quote><p>bar⌟baz</p></quote></quote>"#)

    }
}
