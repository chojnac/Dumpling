//
//  ParserTests_Header.swift
//  DumplingTests
//
//  Created by Wojciech Chojnacki on 31/05/2020.
//  Copyright © 2020 Wojciech Chojnacki. All rights reserved.
//

import XCTest
import Dumpling

final class ParserTests_Header: XCTestCase {
    var parser: Markdown!

    override func setUp() {
        parser = Markdown()
    }


    func testSimple1() throws {
        let reader = "# Header 1 "

        let result = parser.parse(reader).debugString()
        XCTAssertEqual(result, "<h1>Header␣1␣</h1>")
    }

    func testSimple2() throws {
        let reader = " # Header 1 \n\n test"

        let result = parser.parse(reader).debugString()
        XCTAssertEqual(result, "<h1>Header␣1␣</h1><p>␣test</p>")
    }

    func testEmptyLinesStart() throws {
        let reader = "  \n\n # Header 1 \n test"

        let result = parser.parse(reader).debugString()
        XCTAssertEqual(result, "<h1>Header␣1␣</h1><p>␣test</p>")
    }

    func testAdvence() throws {
        let reader = """

        ## Span Elements

        ### Links

        Markdown supports two style of links: *inline* and *reference*.

        In both styles, the link text is delimited by [square brackets].

"""

        let result = parser.parse(reader).debugString()
        XCTAssertEqual(result, "<h2>Span␣Elements</h2><h3>Links</h3><p>␣Markdown␣supports␣two␣style␣of␣links:␣<em>inline</em>␣and␣<em>reference</em>.</p><p>In␣both␣styles,␣the␣link␣text␣is␣delimited␣by␣[square␣brackets].</p>")
    }

}
