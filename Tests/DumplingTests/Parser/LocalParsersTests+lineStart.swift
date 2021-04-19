//
//  LocalParsersTests+lineStart.swift
//  DumplingTests
//
//  Created by Wojciech Chojnacki on 27/03/2021.
//  Copyright © 2021 Dumpling. All rights reserved.
//

import XCTest
import Dumpling

final class LocalParsersTests_lineStart: XCTestCase {

    func test_match() {
        var input = Reader(" \n ").dropFirst(2)
        let result: Void? = Parsers.lineStart.run(&input)

        XCTAssertNotNil(result)
        XCTAssertEqual(input.string(), " ")
    }

    func test_document_match() {
        var input = Reader(" \n ")
        let result: Void? = Parsers.lineStart.run(&input)

        XCTAssertNotNil(result)
        XCTAssertEqual(input.string(), " \n ")
    }

    func test_no_match() {
        var input = Reader(" \n ").dropFirst()
        let result: Void? = Parsers.lineStart.run(&input)

        XCTAssertNil(result)
        XCTAssertEqual(input.string(), "\n ")
    }

}
