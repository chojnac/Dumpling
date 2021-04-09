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
    typealias TC = TestCase.Header
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

}
