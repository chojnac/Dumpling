//
//  BlockquoteBlockFragmentTests.swift
//  Dumpling
//
//  Created by Wojciech Chojnacki on 06/04/2021.
//  Copyright © 2021 Dumpling. All rights reserved.
//

import XCTest
@testable import Dumpling

final class BlockquoteBlockFragmentTests: XCTestCase {
    let fragment = BlockquoteBlockFragment()

    func testSimpleCase01() throws {
        let text = """
> Lorem
 >Ipsum
"""
        var input = Reader(text)
        let result = fragment.contentParser().run(&input)
        let content = try XCTUnwrap(result)
        XCTAssertEqual(content.1, 1)
        XCTAssertEqual(content.0, """
Lorem
Ipsum
""")
    }

    func testLevelsCase01() throws {
        let text = """
> >  Lorem
Ipsum
"""
        var input = Reader(text)
        let result = fragment.contentParser().run(&input)
        let content = try XCTUnwrap(result)
        XCTAssertEqual(content.1, 2)
        XCTAssertEqual(content.0, """
Lorem
Ipsum
""")
    }

    func testLevelsCase02() throws {
        let text = """
>  Lorem
> > Ipsum
"""
        var input = Reader(text)
        let result = fragment.contentParser().run(&input)
        let content = try XCTUnwrap(result)
        XCTAssertEqual(content.1, 1)
        XCTAssertEqual(content.0, """
Lorem
> Ipsum
""")
    }
}
