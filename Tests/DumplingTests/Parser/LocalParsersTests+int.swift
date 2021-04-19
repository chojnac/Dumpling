//
//  LocalParsersTests+int.swift
//  DumplingTests
//
//  Created by Wojciech Chojnacki on 27/03/2021.
//  Copyright © 2021 Dumpling. All rights reserved.
//

import XCTest
import Dumpling

final class LocalParsersTests_int: XCTestCase {

    func test_match() {
        var input = Reader("123456789.")
        let result = Parsers.intNumber().run(&input)
        XCTAssertEqual(result, 123456789)
        XCTAssertEqual(input.string(), ".")
    }

    func test_no_match() {
        var input = Reader(" 1234.")
        let result = Parsers.intNumber().run(&input)
        XCTAssertNil(result)
        XCTAssertEqual(input.string(), " 1234.")
    }

    func test_veryLongNumber_match() {
        var input = Reader("1234567890.")
        let result = Parsers.intNumber().run(&input)
        XCTAssertEqual(result, 123456789)
        XCTAssertEqual(input.string(), "0.")
    }

}
