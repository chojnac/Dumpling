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
    var parser: Markdown!

    override func setUp() {
        parser = Markdown()
    }

    func test_processor_simple_case01() {
        let tc = TestCase.Backslash.case01
        let result = parser.parse(tc.text).debugString()
        XCTAssertEqual(result, tc.parsed)
    }

    func test_processor_simple_case02() {
        let tc = TestCase.Backslash.case02
        let result = parser.parse(tc.text).debugString()
        XCTAssertEqual(result, tc.parsed)
    }

    func test_processor_simple_case03() {
        let tc = TestCase.Backslash.case03
        let result = parser.parse(tc.text).debugString()
        XCTAssertEqual(result, tc.parsed)
    }

    func test_processor_simple_case04() {
        let tc = TestCase.Backslash.case04
        let result = parser.parse(tc.text).debugString()
        XCTAssertEqual(result, tc.parsed)
    }
}
