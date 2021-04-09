//
//  ParserTests_Backslash.swift
//  DumplingTests
//
//  Created by Wojciech Chojnacki on 26/01/2019.
//  Copyright © 2019 Wojciech Chojnacki. All rights reserved.
//

@testable import Dumpling
import XCTest

final class ParserTests_Backslash: XCTestCase {
    typealias TC = TestCase.Backslash
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
