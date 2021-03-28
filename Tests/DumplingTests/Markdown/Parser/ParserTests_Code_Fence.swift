//
//  ParserTests_Code_Fence.swift
//  DumplingTests
//
//  Created by Wojciech Chojnacki on 10/03/2021.
//  Copyright © 2021 Wojciech Chojnacki. All rights reserved.
//

@testable import Dumpling
import XCTest

final class ParserTests_Code_Fence: XCTestCase {
    var parser: Markdown!

    override func setUp() {
        parser = Markdown()
    }

    func test_processor_case01() {
        let tc = TestCase.CodeFence.case01
        let result = parser.parse(tc.text).debugString()
        XCTAssertEqual(result, tc.parsed)
    }

    func test_processor_case02() {
        let tc = TestCase.CodeFence.case02
        let result = parser.parse(tc.text).debugString()
        XCTAssertEqual(result, tc.parsed)
    }
}
