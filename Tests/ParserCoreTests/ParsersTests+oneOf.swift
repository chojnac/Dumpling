//
//  Parsers_oneOf.swift
//  DumplingTests
//
//  Created by Wojciech Chojnacki on 30/11/2019.
//  Copyright © 2019 Wojciech Chojnacki. All rights reserved.
//

import XCTest
import Dumpling

final class Parsers_oneOf: XCTestCase {
    let testText = "Lorem ipsum"
    var input: Reader!

    override func setUp() {
        input = Reader(testText)
    }

    func test_oneOf_case1() {

        let p1 = Parser.just("L")
        let p2 = Parser.just("X")

        let result = Parsers.oneOf(p1, p2).run(&input)
        XCTAssertEqual(result, "L")
        XCTAssertEqual(input.string(), testText)
    }

    func test_oneOf_case2() {

        let p1 = Parser<String>.zero()
        let p2 = Parser.just("L")

        let result = Parsers.oneOf(p1, p2).run(&input)
        XCTAssertEqual(result, "L")
        XCTAssertEqual(input.string(), testText)
    }

    func test_oneOf_no_match() {

        let p1 = Parser<String>.zero()
        let p2 = Parser<String>.zero()

        let result = Parsers.oneOf(p2, p1).run(&input)
        XCTAssertEqual(result, nil)
        XCTAssertEqual(input.string(), testText)
    }

}
