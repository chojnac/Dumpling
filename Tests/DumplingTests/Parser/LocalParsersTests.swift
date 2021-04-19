//
//  LocalParsers.swift
//  DumplingTests
//
//  Created by Wojciech Chojnacki on 28/05/2020.
//  Copyright © 2020 Wojciech Chojnacki. All rights reserved.
//

import Foundation
import XCTest
import Dumpling

final class LocalParsersTests: XCTestCase {

    func test_newLine() {
        var input = Reader("\n\n\ntest")

        let result = Parsers.newLine.map { _ in true }.run(&input)
        XCTAssertNotNil(result)
        XCTAssertEqual(input.string(), "\n\ntest")
    }

    func test_emptyLines_single() {
        var input = Reader("\n\n test")

        let result = Parsers.emptyLines.run(&input)
        XCTAssertEqual(result, 1)
        XCTAssertEqual(input.string(), " test")
    }

    func test_emptyLines() {
        var input = Reader("\n   \n \n test")

        let result = Parsers.emptyLines.run(&input)
        XCTAssertEqual(result, 2)
        XCTAssertEqual(input.string(), " test")
    }

    func test_emptyLines_ignore_single_nl() {
        var input = Reader("\n test")

        let result = Parsers.emptyLines.run(&input)
        XCTAssertEqual(result, nil)
        XCTAssertEqual(input.string(), "\n test")
    }

    func test_emptyLines_endOfFile() {
        var input = Reader("\n   \n \n   ")

        let result = Parsers.emptyLines.run(&input)
        XCTAssertEqual(result, 3)
        XCTAssertEqual(input.string(), "")
    }

    func test_oneOrManySpaces_no_spaces() {
        var input = Reader(#"Lorem"#)

        let result = Parsers.oneOrManySpaces.run(&input)

        XCTAssertEqual(result, nil)
        XCTAssertEqual(input.string(), "Lorem")
    }

    func test_oneOrManySpaces_spaces() {
        var input = Reader(#"  Lorem"#)

        let result = Parsers.oneOrManySpaces.run(&input)

        XCTAssertEqual(result, 2)
        XCTAssertEqual(input.string(), "Lorem")
    }

    func test_oneOrManySpaces_spaces_eof() {
        var input = Reader(#"  "#)

        let result = Parsers.oneOrManySpaces.run(&input)

        XCTAssertEqual(result, 2)
        XCTAssertEqual(input.string(), "")
    }

    func test_one_character_has() {
        var input = Reader(#"Lorem"#)

        let result = Parsers.one(character: "L").run(&input)

        XCTAssertEqual(result, "L")
        XCTAssertEqual(input.string(), "orem")
    }

    func test_one_character_doesnt() {
        var input = Reader(#"Lorem"#)

        let result = Parsers.one(character: "X").run(&input)

        XCTAssertEqual(result, nil)
        XCTAssertEqual(input.string(), "Lorem")
    }

    func test_one_character_empty() {
        var input = Reader(#""#)

        let result = Parsers.one(character: "X").run(&input)

        XCTAssertEqual(result, nil)
        XCTAssertEqual(input.string(), "")
    }

    func test_startsWith_empty() {
        var input = Reader(#""#)

        let result = Parsers.starts(with: "XYZ").run(&input)

        XCTAssertEqual(result, nil)
        XCTAssertEqual(input.string(), "")
    }

    func test_startsWith_match() {
        var input = Reader(#"Lorem"#)

        let result = Parsers.starts(with: "Lor").run(&input)

        XCTAssertEqual(result, "Lor")
        XCTAssertEqual(input.string(), "em")
    }

    func test_startsWith_not_match() {
        var input = Reader(#"Lorem"#)

        let result = Parsers.starts(with: "XYZ").run(&input)

        XCTAssertEqual(result, nil)
        XCTAssertEqual(input.string(), "Lorem")
    }

    func test_startsWith_match_emoji() {
        var input = Reader(#"👨‍👩‍👧‍👦👩‍👩‍👧‍👧Lorem"#)

        let result = Parsers.starts(with: "👨‍👩‍👧‍👦").run(&input)

        XCTAssertEqual(result, "👨‍👩‍👧‍👦")
        XCTAssertEqual(input.string(), "👩‍👩‍👧‍👧Lorem")
    }

    func test_charInSet_success() {
        var input = Reader("123")

        let result = Parsers.char(inSet: .decimalDigits).run(&input)

        XCTAssertEqual(result, "1")
        XCTAssertEqual(input.string(), "23")
    }

    func test_charInSet_failure() {
        var input = Reader("ABC")

        let result = Parsers.char(inSet: .decimalDigits).run(&input)

        XCTAssertNil(result)
        XCTAssertEqual(input.string(), "ABC")
    }

    func test_oneOrMany_match() {
        var input = Reader("AAB")

        let result = Parsers.oneOrMany(Parsers.one(character: "A")).run(&input)

        XCTAssertEqual(result, ["A", "A"])
        XCTAssertEqual(input.string(), "B")
    }

    func test_oneOrMany_no_match() {
        var input = Reader("AAB")

        let result = Parsers.oneOrMany(Parsers.one(character: "1")).run(&input)

        XCTAssertNil(result)
        XCTAssertEqual(input.string(), "AAB")
    }

}
