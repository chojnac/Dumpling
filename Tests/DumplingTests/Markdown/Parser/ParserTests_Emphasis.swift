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
    typealias TC = TestCase.Emphasis
    var parser: Markdown!

    override func setUp() {
        parser = Markdown()
    }

    func test_case01() {
        let tc = TC.case01
        let result = parser.parse(tc.text).debugString()
        XCTAssertEqual(result, tc.parsed)
    }

    func test_case02() {
        let tc = TC.case02
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

    func test_case05() {
        let tc = TC.case05
        let result = parser.parse(tc.text).debugString()
        XCTAssertEqual(result, tc.parsed)
    }

    func test_case06() {
        let tc = TC.case06
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

    func test_case10() {
        let tc = TC.case10
        let result = parser.parse(tc.text).debugString()
        XCTAssertEqual(result, tc.parsed)
    }

    func test_case11() {
        let tc = TC.case11
        let result = parser.parse(tc.text).debugString()
        XCTAssertEqual(result, tc.parsed)
    }

    func test_case12() {
        let tc = TC.case12
        let result = parser.parse(tc.text).debugString()
        XCTAssertEqual(result, tc.parsed)
    }

    func test_case13() {
        let tc = TC.case13
        let result = parser.parse(tc.text).debugString()
        XCTAssertEqual(result, tc.parsed)
    }

    func test_case14() {
        let tc = TC.case14
        let result = parser.parse(tc.text).debugString()
        XCTAssertEqual(result, tc.parsed)
    }

    func test_case15() {
        let tc = TC.case15
        let result = parser.parse(tc.text).debugString()
        XCTAssertEqual(result, tc.parsed)
    }

    func test_case16() {
        let tc = TC.case16
        let result = parser.parse(tc.text).debugString()
        XCTAssertEqual(result, tc.parsed)
    }

    func test_case17() {
        let tc = TC.case17
        let result = parser.parse(tc.text).debugString()
        XCTAssertEqual(result, tc.parsed)
    }

    func test_case18() {
        let tc = TC.case18
        let result = parser.parse(tc.text).debugString()
        XCTAssertEqual(result, tc.parsed)
    }

    func test_case19() {
        let tc = TC.case19
        let result = parser.parse(tc.text).debugString()
        XCTAssertEqual(result, tc.parsed)
    }

    func test_case20() {
        let tc = TC.case20
        let result = parser.parse(tc.text).debugString()
        XCTAssertEqual(result, tc.parsed)
    }

    func test_case21() {
        let tc = TC.case21
        let result = parser.parse(tc.text).debugString()
        XCTAssertEqual(result, tc.parsed)
    }

    func test_case22() {
        let tc = TC.case22
        let result = parser.parse(tc.text).debugString()
        XCTAssertEqual(result, tc.parsed)
    }
}
