//
//  LocalParsersTests+minMax.swift
//  DumplingTests
//
//  Created by Wojciech Chojnacki on 12/03/2021.
//  Copyright © 2021 Wojciech Chojnacki. All rights reserved.
//

import Foundation
import XCTest
import Dumpling

final class LocalParsersTests_minMax: XCTestCase {

    func test_min_match() {
        var input = Substring("aaaa ")

        let result = Parsers.minMax(parser: Parsers.one(character: "a"), min: 2).run(&input)
        XCTAssertEqual(result, ["a", "a", "a", "a"])
        XCTAssertEqual(String(input), " ")
    }

    func test_min_no_match() {
        var input = Substring("baaa ")

        let result = Parsers.minMax(parser: Parsers.one(character: "b"), min: 2).run(&input)
        XCTAssertNil(result)
        XCTAssertEqual(String(input), "baaa ")
    }

    func test_min_max_equal_match() {
        var input = Substring("aaaa ")

        let result = Parsers.minMax(parser: Parsers.one(character: "a"), min: 2, max: 2).run(&input)
        XCTAssertEqual(result, ["a", "a"])
        XCTAssertEqual(String(input), "aa ")
    }

    func test_min_zero_max_greather_match() {
        var input = Substring("aaaa ")

        let result = Parsers.minMax(parser: Parsers.one(character: "a"), min: 0, max: 2).run(&input)
        XCTAssertEqual(result, ["a", "a"])
        XCTAssertEqual(String(input), "aa ")
    }

    func test_min_zero_case1_match() {
        var input = Substring("aaaa ")

        let result = Parsers.minMax(parser: Parsers.one(character: "a"), min: 0).run(&input)
        XCTAssertEqual(result, ["a", "a", "a", "a"])
        XCTAssertEqual(String(input), " ")
    }

    func test_min_zero_case2_match() {
        var input = Substring("aaaa ")

        let result = Parsers.minMax(parser: Parsers.one(character: "b"), min: 0).run(&input)
        XCTAssertEqual(result, [])
        XCTAssertEqual(String(input), "aaaa ")
    }

    func test_min_max_zero_match() {
        var input = Substring("aaaa ")

        let result = Parsers.minMax(parser: Parsers.one(character: "a"), min: 0, max: 0).run(&input)
        XCTAssertEqual(result, [])
        XCTAssertEqual(String(input), "aaaa ")
    }
}
