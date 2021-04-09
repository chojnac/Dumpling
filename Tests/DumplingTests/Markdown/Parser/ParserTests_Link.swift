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
    typealias TC = TestCase.Link
    var parser: Markdown!

    override func setUp() {
        parser = Markdown()
    }

    func test_case01() {
        let tc = TC.case01
        let result = parser.parse(tc.text).debugString()
        XCTAssertEqual(result, tc.parsed)
    }

    func test_case02a() {
        let tc = TC.case02a
        let result = parser.parse(tc.text).debugString()
        XCTAssertEqual(result, tc.parsed)
    }

    func test_case02b() {
        let tc = TC.case02b
        let result = parser.parse(tc.text).debugString()
        XCTAssertEqual(result, tc.parsed)
    }

    func test_case02c() {
        let tc = TC.case02c
        let result = parser.parse(tc.text).debugString()
        XCTAssertEqual(result, tc.parsed)
    }

    func test_case03() {
        let tc = TC.case03
        let result = parser.parse(tc.text).debugString()
        XCTAssertEqual(result, tc.parsed)
    }

    func test_case04() {
        let tc = TC.case04
        let result = parser.parse(tc.text).debugString()
        XCTAssertEqual(result, tc.parsed)
    }

    // Nested styles not yet supported
//    func test_case05() {
//        let tc = TC.case05
//        let result = parser.parse(tc.text).debugString()
//        XCTAssertEqual(result, tc.parsed)
//    }

    func test_case06() {
        let tc = TC.case06
        let result = parser.parse(tc.text).debugString()
        XCTAssertEqual(result, tc.parsed)
    }

    func test_case07() {
        let tc = TC.case07
        let result = parser.parse(tc.text).debugString()
        XCTAssertEqual(result, tc.parsed)
    }

    func test_case08() {
        let tc = TC.case08
        let result = parser.parse(tc.text).debugString()
        XCTAssertEqual(result, tc.parsed)
    }

    func test_case09() {
        let tc = TC.case09
        let result = parser.parse(tc.text).debugString()
        XCTAssertEqual(result, tc.parsed)
    }
}
