//
//  LocalParsersTests+stringUntil.swift
//  DumplingTests
//
//  Created by Wojciech Chojnacki on 27/03/2021.
//  Copyright © 2021 Dumpling. All rights reserved.
//

import Foundation
import XCTest
import Dumpling

final class LocalParsersTests_stringUntil: XCTestCase {

    func test_simple() {
        var input = Reader("Lorem")

        let exit = pChar(character: "r").mapToVoid

        let parser = Parsers.stringUntil(stop: exit)

        let result = parser.run(&input)

        XCTAssertEqual(result, "Lo")
        XCTAssertEqual(input.string(), "rem")
    }

    func test_endOfData() {
        var input = Reader("Lorem")

        let exit = pChar(character: "1").mapToVoid

        let parser = Parsers.stringUntil(stop: exit)

        let result = parser.run(&input)

        XCTAssertEqual(result, "Lorem")
        XCTAssertEqual(input.string(), "")
    }
}
