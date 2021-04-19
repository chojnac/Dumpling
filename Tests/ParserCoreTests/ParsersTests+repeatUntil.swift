//
//  ParsersTests+repeatUntil.swift
//  DumplingTests
//
//  Created by Wojciech Chojnacki on 27/03/2021.
//  Copyright © 2021 Dumpling. All rights reserved.
//

import XCTest
import Dumpling

final class ParsersTests_repeatUntil: XCTestCase {

    func test_repeatUntil_match() {
        var input = Reader("Lorem ipsum")
        let result = Parsers.repeatUntil(
            Parsers.char(inSet: .alphanumerics),
            stop: Parsers.space
        )
        .map({ characters, _ in String(characters) })
        .run(&input)

        XCTAssertEqual(result, "Lorem")
        XCTAssertEqual(input.string(), "ipsum")
    }

    func test_repeatUntil_no_match() {
        var input = Reader("Lorem ipsum")
        let result = Parsers.repeatUntil(
            Parsers.char(inSet: .whitespaces),
            stop: Parsers.space
        )
        .map({ characters, _ in String(characters) })
        .run(&input)

        XCTAssertEqual(result, "")
        XCTAssertEqual(input.string(), "Lorem ipsum")
    }

    func test_repeatUntil_emptyInput_no_match() {
        var input = Reader("")
        let result = Parsers.repeatUntil(
            Parsers.char(inSet: .whitespaces),
            stop: Parsers.space
        )
        .map({ characters, _ in String(characters) })
        .run(&input)

        XCTAssertNil(result)
        XCTAssertEqual(input.string(), "")
    }

}
