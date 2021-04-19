//
//  LocalParsersTests+minCharacters.swift
//  DumplingTests
//
//  Created by Wojciech Chojnacki on 27/03/2021.
//  Copyright © 2021 Dumpling. All rights reserved.
//

import XCTest
import Dumpling

final class LocalParsersTests_minCharacters: XCTestCase {

    func test_min_match() {
        var input = Reader("```` ")

        let result = Parsers.min(character: "`", min: 3).run(&input)

        XCTAssertEqual(result, 4)
        XCTAssertEqual(input.string(), " ")
    }

    func test_min_eof_match() {
        var input = Reader("```")

        let result = Parsers.min(character: "`", min: 3).run(&input)

        XCTAssertEqual(result, 3)
        XCTAssertEqual(input.string(), "")
    }

    func test_min_no_match() {
        var input = Reader("`` ")

        let result = Parsers.min(character: "`", min: 3).run(&input)

        XCTAssertNil(result)
        XCTAssertEqual(input.string(), "`` ")
    }

    func test_min_eof_no_match() {
        var input = Reader("``")

        let result = Parsers.min(character: "`", min: 3).run(&input)

        XCTAssertNil(result)
        XCTAssertEqual(input.string(), "``")
    }

}
