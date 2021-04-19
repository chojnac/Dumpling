//
//  ParserTests.swift
//  DumplingTests
//
//  Created by Wojciech Chojnacki on 30/11/2019.
//  Copyright © 2019 Wojciech Chojnacki. All rights reserved.
//

import XCTest
import Dumpling

final class ParserTests: XCTestCase {
    let testText = "Lorem ipsum"
    var input: Reader!

    override func setUp() {
        input = Reader(testText)
    }

    func test_just() {
        let p = Parser<String>.just("XYZ")

        let result = p.run(&input)

        XCTAssertEqual(result, "XYZ")
        XCTAssertEqual(input.string(), testText)
    }

    func test_zero() {
        let p = Parser<String>.zero()

        let result = p.run(&input)

        XCTAssertNil(result)
        XCTAssertEqual(input.string(), testText)
    }

    func test_map_with_result() {

        let parser = Parser<String>.just("L").map {
            "0\($0)0"
        }

        let result = parser.run(&input)
        XCTAssertEqual(result, "0L0")
        XCTAssertEqual(input.string(), testText)
    }

    func test_flatMap_with_result() {
        func handle(_ result: String) -> Parser<Bool> {
            return .just(true)
        }

        let parser1 = Parser.just("L")
            .flatMap(handle)
        let parser2 = Parser<String>.zero()
            .flatMap(handle)

        let result1 = parser1.run(&input)
        let result2 = parser2.run(&input)

        XCTAssertEqual(result1, true)
        XCTAssertEqual(result2, nil)
        XCTAssertEqual(input.string(), testText)
    }

    func test_lookAhead() {
        var input2 = Reader(testText)

        let p = Parser<String>("p") {  reader in
            reader = Reader("")
            return "XYZ"
        }

        let result1 = p.lookAhead().run(&input)
        let result2 = Parser<String>.zero().lookAhead().run(&input)
        let result3 = p.run(&input2)

        XCTAssertEqual(result1, "XYZ")
        XCTAssertNil(result2)
        XCTAssertEqual(result3, "XYZ")
        XCTAssertEqual(input.string(), testText)
        XCTAssertEqual(input2.string(), "")
        
    }

}
