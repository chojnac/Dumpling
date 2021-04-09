//
//  ParserTests_Strikethrough.swift
//  DumplingTests
//
//  Created by Wojciech Chojnacki on 16/06/2019.
//  Copyright © 2019 Wojciech Chojnacki. All rights reserved.
//

@testable import Dumpling
import XCTest

final class ParserTests_Strikethrough: XCTestCase {
    typealias TC = TestCase.Strikethrough
    var parser: Markdown!

    override func setUp() {
        parser = Markdown()
    }

    func test_processor_simple_case01() {
        let tc = TC.case01
        let result = parser.parse(tc.text).debugString()
        XCTAssertEqual(result, tc.parsed)
    }

    func test_processor_simple_case02() {
        let tc = TC.case02
        let result = parser.parse(tc.text).debugString()
        XCTAssertEqual(result, tc.parsed)
    }

    func test_processor_simple_case03() {
        let tc = TC.case03
        let result = parser.parse(tc.text).debugString()
        XCTAssertEqual(result, tc.parsed)
    }
}
