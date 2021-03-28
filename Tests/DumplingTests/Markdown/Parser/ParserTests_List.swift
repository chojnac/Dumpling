//
//  ParserTests_List.swift
//  DumplingTests
//
//  Created by Wojciech Chojnacki on 13/12/2019.
//  Copyright © 2019 Wojciech Chojnacki. All rights reserved.
//

import Dumpling
import XCTest

final class ParserTests_List: XCTestCase {
    var parser: Markdown!

    override func setUp() {
        parser = Markdown()
    }

    func test_processor_case01() {
        let tc = TestCase.List.case01
        let result = parser.parse(tc.text).debugString()
        XCTAssertEqual(result, tc.parsed)
    }

    func test_processor_case02() {
        let tc = TestCase.List.case02
        let result = parser.parse(tc.text).debugString()
        XCTAssertEqual(result, tc.parsed)
    }

    func test_processor_case03() {
        let tc = TestCase.List.case03
        let result = parser.parse(tc.text).debugString()
        XCTAssertEqual(result, tc.parsed)
    }

    func test_processor_case04() {
        let tc = TestCase.List.case04
        let result = parser.parse(tc.text).debugString()
        XCTAssertEqual(result, tc.parsed)
    }

    func test_processor_case05() {
        let tc = TestCase.List.case05
        let result = parser.parse(tc.text).debugString()
        XCTAssertEqual(result, tc.parsed)
    }

    func test_processor_case06() {
        let tc = TestCase.List.case06
        let result = parser.parse(tc.text).debugString()
        XCTAssertEqual(result, tc.parsed)
    }

    func test_processor_case07() {
        let tc = TestCase.List.case07
        let result = parser.parse(tc.text).debugString()
        XCTAssertEqual(result, tc.parsed)
    }

    func test_processor_case08() {
        let tc = TestCase.List.case08
        let result = parser.parse(tc.text).debugString()
        XCTAssertEqual(result, tc.parsed)
    }

    func test_processor_case09() {
        let tc = TestCase.List.case09
        let result = parser.parse(tc.text).debugString()
        XCTAssertEqual(result, tc.parsed)
    }

    func test_processor_case10() {
        let tc = TestCase.List.case10
        let result = parser.parse(tc.text).debugString()
        XCTAssertEqual(result, tc.parsed)
    }
}
