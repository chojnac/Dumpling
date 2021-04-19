//
//  EmphasisInlineFragmentTests.swift
//  DumplingTests
//
//  Created by Wojciech Chojnacki on 10/04/2021.
//  Copyright © 2021 Dumpling. All rights reserved.
//

import XCTest
@testable import Dumpling

final class EmphasisInlineFragmentTests: XCTestCase {
    typealias UnderTest = EmphasisInlineFragment

    func delimiterRun()  -> Parser<(character: Character, lhs: Character?, rhs: Character?, count: Int)> {
        EmphasisDelimterRunParser()
            .flatMap { step in
                var lhsReader = step.lhsReader
                let isDocStart = Parsers.isDocStart.mapTo(true).run(&lhsReader) ?? false
                let lhs = isDocStart ? nil : EmphasisCheckPreceded(forParser: Parsers.anyCharacter).run(&lhsReader)
                let rhs = step.rhsReader.first

                return .just((step.character, lhs, rhs, step.count))
        }
    }
    func test_delimiterRun_case01() throws {
        var input = Reader("a___b").dropFirst()
        let value = delimiterRun().run(&input)
        let result = try XCTUnwrap(value)
        XCTAssertEqual(input.string(), "___b")
        XCTAssertEqual(result.character, "_")
        XCTAssertEqual(result.count, 3)
        XCTAssertEqual(result.lhs, "a")
        XCTAssertEqual(result.rhs, "b")
    }

    func test_delimiterRun_case02() throws {
        var input = Reader("___").dropFirst()
        let value = delimiterRun().run(&input)
        let result = try XCTUnwrap(value)
        XCTAssertEqual(input.string(), "__")
        XCTAssertEqual(result.character, "_")
        XCTAssertEqual(result.count, 3)
        XCTAssertNil(result.lhs)
        XCTAssertNil(result.rhs)
    }

    func test_checkPreceded_case01() {
        var input = Reader("abc").dropFirst()
        let result = EmphasisCheckPreceded(forParser: Parsers.anyCharacter)
            .run(&input)
        XCTAssertEqual(result, "a")
        XCTAssertEqual(input.string(), "bc")
    }

    func test_checkPreceded_case02() {
        var input = Reader("abc").dropFirst()
        let result = EmphasisCheckPreceded(UInt(2), forParser: Parsers.anyCharacter)
            .run(&input)
        XCTAssertEqual(result, "a")
        XCTAssertEqual(input.string(), "bc")
    }

    func test_checkPreceded_case03() {
        var input = Reader("abc").dropFirst(3)
        let result = EmphasisCheckPreceded(forParser: Parsers.anyCharacter)
            .run(&input)
        XCTAssertEqual(result, "c")
        XCTAssertEqual(input.string(), "")
    }

    let underTest = UnderTest(kind: .normal)

    func test_leftOnly_case01() throws {
        var input = Reader("**abc")

        let value = underTest.baseDelimiterCheck().run(&input)
        let result = try XCTUnwrap(value)

        XCTAssertTrue(result.check.isLeftFlanky)
        XCTAssertFalse(result.check.isRightFlanky)
        XCTAssertEqual(result.step.character, "*")
        XCTAssertEqual(result.step.count, 2)
    }

    func test_leftOnly_case02() throws {
        var input = Reader("_abc")

        let value = underTest.baseDelimiterCheck().run(&input)
        let result = try XCTUnwrap(value)

        XCTAssertTrue(result.check.isLeftFlanky)
        XCTAssertFalse(result.check.isRightFlanky)
        XCTAssertEqual(result.step.character, "_")
        XCTAssertEqual(result.step.count, 1)
    }

    func test_leftOnly_case03() throws {
        var input = Reader(#"**"abc""#)
        let value = underTest.baseDelimiterCheck().run(&input)
        let result = try XCTUnwrap(value)

        XCTAssertTrue(result.check.isLeftFlanky)
        XCTAssertFalse(result.check.isRightFlanky)
        XCTAssertEqual(result.step.character, "*")
        XCTAssertEqual(result.step.count, 2)
    }

    func test_leftOnly_case04() throws {
        var input = Reader(#"_"abc""#)
        let value = underTest.baseDelimiterCheck().run(&input)
        let result = try XCTUnwrap(value)

        XCTAssertTrue(result.check.isLeftFlanky)
        XCTAssertFalse(result.check.isRightFlanky)
        XCTAssertEqual(result.step.character, "_")
        XCTAssertEqual(result.step.count, 1)
    }

    func test_leftOnly_case05() throws {
        var input = Reader("**abc").dropFirst()
        let value = underTest.baseDelimiterCheck().run(&input)
        let result = try XCTUnwrap(value)

        XCTAssertTrue(result.check.isLeftFlanky)
        XCTAssertFalse(result.check.isRightFlanky)
        XCTAssertEqual(result.step.character, "*")
        XCTAssertEqual(result.step.count, 2)
    }

    func test_rightOnly_case01() throws {
        var input = Reader("abc***").dropFirst(3)
        let value = underTest.baseDelimiterCheck().run(&input)
        let result = try XCTUnwrap(value)

        XCTAssertFalse(result.check.isLeftFlanky)
        XCTAssertTrue(result.check.isRightFlanky)
        XCTAssertEqual(result.step.character, "*")
        XCTAssertEqual(result.step.count, 3)
    }

    func test_rightOnly_case02() throws {
        var input = Reader("abc_").dropFirst(3)
        let value = underTest.baseDelimiterCheck().run(&input)
        let result = try XCTUnwrap(value)

        XCTAssertFalse(result.check.isLeftFlanky)
        XCTAssertTrue(result.check.isRightFlanky)
        XCTAssertEqual(result.step.character, "_")
        XCTAssertEqual(result.step.count, 1)
    }

    func test_rightOnly_case03() throws {
        var input = Reader(#""abc"**"#).dropFirst(5)
        let value = underTest.baseDelimiterCheck().run(&input)
        let result = try XCTUnwrap(value)

        XCTAssertFalse(result.check.isLeftFlanky)
        XCTAssertTrue(result.check.isRightFlanky)
        XCTAssertEqual(result.step.character, "*")
        XCTAssertEqual(result.step.count, 2)
    }

    func test_rightOnly_case04() throws {
        var input = Reader(#""abc"_"#).dropFirst(5)
        let value = underTest.baseDelimiterCheck().run(&input)
        let result = try XCTUnwrap(value)

        XCTAssertFalse(result.check.isLeftFlanky)
        XCTAssertTrue(result.check.isRightFlanky)
        XCTAssertEqual(result.step.character, "_")
        XCTAssertEqual(result.step.count, 1)
    }

    func test_both_case01() throws {
        var input = Reader("abc**def").dropFirst(3)
        let value = underTest.baseDelimiterCheck().run(&input)
        let result = try XCTUnwrap(value)

        XCTAssertTrue(result.check.isLeftFlanky)
        XCTAssertTrue(result.check.isRightFlanky)
        XCTAssertEqual(result.step.character, "*")
        XCTAssertEqual(result.step.count, 2)
    }

    func test_both_case02() throws {
        var input = Reader(#""abc"_"def""#).dropFirst(5)
        let value = underTest.baseDelimiterCheck().run(&input)
        let result = try XCTUnwrap(value)

        XCTAssertTrue(result.check.isLeftFlanky)
        XCTAssertTrue(result.check.isRightFlanky)
        XCTAssertEqual(result.step.character, "_")
        XCTAssertEqual(result.step.count, 1)
    }

    func test_neither_case01() throws {
        var input = Reader(#"abc ** def"#).dropFirst(4)
        let value = underTest.baseDelimiterCheck().run(&input)
        let result = try XCTUnwrap(value)

        XCTAssertFalse(result.check.isLeftFlanky)
        XCTAssertFalse(result.check.isRightFlanky)
        XCTAssertEqual(result.step.character, "*")
        XCTAssertEqual(result.step.count, 2)
    }

    func test_neither_case02() throws {
        var input = Reader(#"a _ b"#).dropFirst(2)
        let value = underTest.baseDelimiterCheck().run(&input)
        let result = try XCTUnwrap(value)

        XCTAssertFalse(result.check.isLeftFlanky)
        XCTAssertFalse(result.check.isRightFlanky)
        XCTAssertEqual(result.step.character, "_")
        XCTAssertEqual(result.step.count, 1)
    }
    
}
