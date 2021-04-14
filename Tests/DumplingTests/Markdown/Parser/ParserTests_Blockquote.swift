//
//  ParserTests_Blockquote.swift
//  Dumpling
//
//  Created by Wojciech Chojnacki on 06/04/2021.
//  Copyright © 2021 Dumpling. All rights reserved.
//

@testable import Dumpling
import XCTest

final class ParserTests_Blockquote: XCTestCase {
    typealias TC = TestCase.Blockquote
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

    // FIXME: fix parser to pass this case
//    func test_case06() {
//        let tc = TC.case06
//        let result = parser.parse(tc.text).debugString()
//        XCTAssertEqual(result, tc.parsed)
//    }

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

    func test_case20() {
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
}
