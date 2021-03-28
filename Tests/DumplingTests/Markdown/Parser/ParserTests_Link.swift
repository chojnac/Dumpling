//
//  ParserTests_Link.swift
//  DumplingTests
//
//  Created by Wojciech Chojnacki on 30/06/2019.
//  Copyright © 2019 Wojciech Chojnacki. All rights reserved.
//

@testable import Dumpling
import XCTest

final class ParserTests_Link: XCTestCase {
    var parser: Markdown!

    override func setUp() {
        parser = Markdown()
    }

    func test_processor_case01() {
        let tc = TestCase.Link.case01
        let result = parser.parse(tc.text).debugString()
        XCTAssertEqual(result, tc.parsed)
    }

    func test_processor_case02a() {
        let tc = TestCase.Link.case02a
        let result = parser.parse(tc.text).debugString()
        XCTAssertEqual(result, tc.parsed)
    }

    func test_processor_case02b() {
        let tc = TestCase.Link.case02b
        let result = parser.parse(tc.text).debugString()
        XCTAssertEqual(result, tc.parsed)
    }

    func test_processor_case02c() {
        let tc = TestCase.Link.case02c
        let result = parser.parse(tc.text).debugString()
        XCTAssertEqual(result, tc.parsed)
    }

    func test_processor_case03() {
        let tc = TestCase.Link.case03
        let result = parser.parse(tc.text).debugString()
        XCTAssertEqual(result, tc.parsed)
    }

    func test_processor_case04() {
        let tc = TestCase.Link.case04
        let result = parser.parse(tc.text).debugString()
        XCTAssertEqual(result, tc.parsed)
    }

    // Nested styles not yet supported
//    func test_processor_case05() {
//        let tc = TestCase.Link.case05
//        let result = parser.parse(tc.text).debugString()
//        XCTAssertEqual(result, tc.parsed)
//    }

    func test_processor_case06() {
        let tc = TestCase.Link.case06
        let result = parser.parse(tc.text).debugString()
        XCTAssertEqual(result, tc.parsed)
    }

    func test_processor_case07() {
        let tc = TestCase.Link.case07
        let result = parser.parse(tc.text).debugString()
        XCTAssertEqual(result, tc.parsed)
    }

    func test_processor_case08() {
        let tc = TestCase.Link.case08
        let result = parser.parse(tc.text).debugString()
        XCTAssertEqual(result, tc.parsed)
    }

    func test_processor_case09() {
        let tc = TestCase.Link.case09
        let result = parser.parse(tc.text).debugString()
        XCTAssertEqual(result, tc.parsed)
    }
}
