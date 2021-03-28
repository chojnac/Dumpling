//
//  ParserTests_Emphasis.swift
//  DumplingTests
//
//  Created by Wojciech Chojnacki on 30/11/2019.
//  Copyright © 2019 Wojciech Chojnacki. All rights reserved.
//

import Dumpling
import XCTest

final class ParserTests_Emphasis: XCTestCase {
    var parser: Markdown!

    override func setUp() {
        parser = Markdown()
    }

    func test_processor_simple_case01() {
        let tc = TestCase.Emphasis.case01
        let result = parser.parse(tc.text).debugString()
        XCTAssertEqual(result, tc.parsed)
    }

    func test_processor_simple_case02() {
        let tc = TestCase.Emphasis.case02
        let result = parser.parse(tc.text).debugString()
        XCTAssertEqual(result, tc.parsed)
    }

    func test_processor_simple_case03() {
        let tc = TestCase.Emphasis.case03
        let result = parser.parse(tc.text).debugString()
        XCTAssertEqual(result, tc.parsed)
    }

    func test_processor_simple_case04() {
        let tc = TestCase.Emphasis.case04
        let result = parser.parse(tc.text).debugString()
        XCTAssertEqual(result, tc.parsed)
    }

    func test_processor_simple_case05() {
        let tc = TestCase.Emphasis.case05
        let result = parser.parse(tc.text).debugString()
        XCTAssertEqual(result, tc.parsed)
    }

    func test_processor_simple_case06() {
        let tc = TestCase.Emphasis.case06
        let result = parser.parse(tc.text).debugString()
        XCTAssertEqual(result, tc.parsed)
    }

    func test_processor_simple_case08() {
        let tc = TestCase.Emphasis.case08
        let result = parser.parse(tc.text).debugString()
        XCTAssertEqual(result, tc.parsed)
    }

    func test_processor_simple_case09() {
        let tc = TestCase.Emphasis.case09
        let result = parser.parse(tc.text).debugString()
        XCTAssertEqual(result, tc.parsed)
    }

    func test_processor_simple_case10() {
        let tc = TestCase.Emphasis.case10
        let result = parser.parse(tc.text).debugString()
        XCTAssertEqual(result, tc.parsed)
    }

    func test_processor_simple_case110() {
        let tc = TestCase.Emphasis.case11
        let result = parser.parse(tc.text).debugString()
        XCTAssertEqual(result, tc.parsed)
    }

    func test_processor_simple_case120() {
        let tc = TestCase.Emphasis.case12
        let result = parser.parse(tc.text).debugString()
        XCTAssertEqual(result, tc.parsed)
    }
}
