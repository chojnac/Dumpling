//
//  LinkInlineFragmentTests.swift
//  DumplingTests
//
//  Created by Wojciech Chojnacki on 31/05/2020.
//  Copyright © 2020 Wojciech Chojnacki. All rights reserved.
//

import XCTest
@testable import Dumpling

final class LinkInlineFragmentTests: XCTestCase {
    func test_case01() {
        var input = Substring("[this \\[[is test]]")
        let result = LinkInlineFragment.balancedBrackets("[").run(&input)
        XCTAssertEqual(result, "this [[is test]")
        XCTAssertEqual(String(input), "")
    }

    func test_case01_noMatch() {
        var input = Substring("[this]")
        let result = LinkInlineFragment.balancedBrackets("<").run(&input)
        XCTAssertNil(result)
        XCTAssertEqual(String(input), "[this]")
    }

    func test_case02() {
        var input = Substring("/uri")
        let result = LinkInlineFragment.balancedBrackets("<").run(&input)
        XCTAssertNil(result)
    }

    func test_case03() {
        var input = Substring("\"test title\"")
        let result = LinkInlineFragment.balancedBrackets("\"").run(&input)
        XCTAssertEqual(result, "test title")
        XCTAssertEqual(String(input), "")
    }

    func test_case04() {
        var input = Substring("(title)")
        let result = LinkInlineFragment.balancedBrackets("(").run(&input)
        XCTAssertEqual(result, "title")
        XCTAssertEqual(String(input), "")
    }

    func testProcessSourceString_simple_success() {
        let input = "/uri"

        let result = LinkInlineFragment.processSourceString(input)

        XCTAssertEqual(result?.0, AST.LinkNode.LinkValue.inline("/uri"))
        XCTAssertNil(result?.1)
    }

    func testProcessSourceString_empty_success() {
        let input = ""

        let result = LinkInlineFragment.processSourceString(input)

        XCTAssertEqual(result?.0, AST.LinkNode.LinkValue.inline(""))
        XCTAssertNil(result?.1)
    }

    func testProcessSourceString_simpleWithSpaces_success() {
        let input = " /uri "

        let result = LinkInlineFragment.processSourceString(input)

        XCTAssertEqual(result?.0, AST.LinkNode.LinkValue.inline("/uri"))
        XCTAssertNil(result?.1)
    }

    func testProcessSourceString_illegalCharacter() {
        let input = "/uri \ntest"

        let result = LinkInlineFragment.processSourceString(input)

        XCTAssertNil(result)
    }

    func testProcessSourceString_simpleWithTitle1_success() {
        let input = #" /uri "this is title""#

        let result = LinkInlineFragment.processSourceString(input)

        XCTAssertEqual(result?.0, AST.LinkNode.LinkValue.inline("/uri"))
        XCTAssertEqual(result?.1, "this is title")
    }

    func testProcessSourceString_simpleWithTitle2_success() {
        let input = #" /uri (this is title)"#

        let result = LinkInlineFragment.processSourceString(input)

        XCTAssertEqual(result?.0, AST.LinkNode.LinkValue.inline("/uri"))
        XCTAssertEqual(result?.1, "this is title")
    }

    func testProcessSourceString_simpleWithTitle3_failure() {
        let input = " /uri (this \nis title)"

        let result = LinkInlineFragment.processSourceString(input)

        XCTAssertNil(result)
    }

    func testLinkSource_simple() {
        var reader = Substring("(/uri)")

        let result = LinkInlineFragment.linkSource().run(&reader)

        XCTAssertEqual(result?.0, AST.LinkNode.LinkValue.inline("/uri"))
        XCTAssertNil(result?.1)
    }

    func testLinkSource_illegalCharacter() {
        var reader = Substring("(/uri \ntest)")

        let result = LinkInlineFragment.linkSource().run(&reader)

        XCTAssertNil(result)
    }
}
