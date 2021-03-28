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
        var input = Substring("\n\n\ntest")

        let result = Parsers.newLine.map { _ in true }.run(&input)
        XCTAssertNotNil(result)
        XCTAssertEqual(String(input), "\n\ntest")
    }

    func test_emptyLines_single() {
        var input = Substring("\n\n test")

        let result = Parsers.emptyLines.run(&input)
        XCTAssertEqual(result, 1)
        XCTAssertEqual(String(input), " test")
    }

    func test_emptyLines() {
        var input = Substring("\n   \n \n test")

        let result = Parsers.emptyLines.run(&input)
        XCTAssertEqual(result, 2)
        XCTAssertEqual(String(input), " test")
    }

    func test_emptyLines_ignore_single_nl() {
        var input = Substring("\n test")

        let result = Parsers.emptyLines.run(&input)
        XCTAssertEqual(result, nil)
        XCTAssertEqual(String(input), "\n test")
    }

    func test_emptyLines_endOfFile() {
        var input = Substring("\n   \n \n   ")

        let result = Parsers.emptyLines.run(&input)
        XCTAssertEqual(result, 3)
        XCTAssertEqual(String(input), "")
    }

    func test_oneOrManySpaces_no_spaces() {
        var input = Substring(#"Lorem"#)

        let result = Parsers.oneOrManySpaces.run(&input)

        XCTAssertEqual(result, nil)
        XCTAssertEqual(String(input), "Lorem")
    }

    func test_oneOrManySpaces_spaces() {
        var input = Substring(#"  Lorem"#)

        let result = Parsers.oneOrManySpaces.run(&input)

        XCTAssertEqual(result, 2)
        XCTAssertEqual(String(input), "Lorem")
    }

    func test_oneOrManySpaces_spaces_eof() {
        var input = Substring(#"  "#)

        let result = Parsers.oneOrManySpaces.run(&input)

        XCTAssertEqual(result, 2)
        XCTAssertEqual(String(input), "")
    }

    func test_one_character_has() {
        var input = Substring(#"Lorem"#)

        let result = Parsers.one(character: "L").run(&input)

        XCTAssertEqual(result, "L")
        XCTAssertEqual(String(input), "orem")
    }

    func test_one_character_doesnt() {
        var input = Substring(#"Lorem"#)

        let result = Parsers.one(character: "X").run(&input)

        XCTAssertEqual(result, nil)
        XCTAssertEqual(String(input), "Lorem")
    }

    func test_one_character_empty() {
        var input = Substring(#""#)

        let result = Parsers.one(character: "X").run(&input)

        XCTAssertEqual(result, nil)
        XCTAssertEqual(String(input), "")
    }

    func test_startsWith_empty() {
        var input = Substring(#""#)

        let result = Parsers.starts(with: "XYZ").run(&input)

        XCTAssertEqual(result, nil)
        XCTAssertEqual(String(input), "")
    }

    func test_startsWith_match() {
        var input = Substring(#"Lorem"#)

        let result = Parsers.starts(with: "Lor").run(&input)

        XCTAssertEqual(result, "Lor")
        XCTAssertEqual(String(input), "em")
    }

    func test_startsWith_not_match() {
        var input = Substring(#"Lorem"#)

        let result = Parsers.starts(with: "XYZ").run(&input)

        XCTAssertEqual(result, nil)
        XCTAssertEqual(String(input), "Lorem")
    }

    func test_startsWith_match_emoji() {
        var input = Substring(#"👨‍👩‍👧‍👦👩‍👩‍👧‍👧Lorem"#)

        let result = Parsers.starts(with: "👨‍👩‍👧‍👦").run(&input)

        XCTAssertEqual(result, "👨‍👩‍👧‍👦")
        XCTAssertEqual(String(input), "👩‍👩‍👧‍👧Lorem")
    }

    func test_charInSet_success() {
        var input = Substring("123")

        let result = Parsers.char(inSet: .decimalDigits).run(&input)

        XCTAssertEqual(result, "1")
        XCTAssertEqual(String(input), "23")
    }

    func test_charInSet_failure() {
        var input = Substring("ABC")

        let result = Parsers.char(inSet: .decimalDigits).run(&input)

        XCTAssertNil(result)
        XCTAssertEqual(String(input), "ABC")
    }

    func test_oneOrMany_match() {
        var input = Substring("AAB")

        let result = Parsers.oneOrMany(Parsers.one(character: "A")).run(&input)

        XCTAssertEqual(result, ["A", "A"])
        XCTAssertEqual(String(input), "B")
    }

    func test_oneOrMany_no_match() {
        var input = Substring("AAB")

        let result = Parsers.oneOrMany(Parsers.one(character: "1")).run(&input)

        XCTAssertNil(result)
        XCTAssertEqual(String(input), "AAB")
    }

}
