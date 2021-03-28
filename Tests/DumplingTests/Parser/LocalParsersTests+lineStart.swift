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
        let text = String(" \n ")
        let idx = text.index(text.startIndex, offsetBy: 2)
        var input = text[idx...]
        let result: Void? = Parsers.lineStart.run(&input)

        XCTAssertNotNil(result)
        XCTAssertEqual(String(input), " ")
    }

    func test_document_match() {
        let text = String(" \n ")
        var input = text[text.startIndex...]
        let result: Void? = Parsers.lineStart.run(&input)

        XCTAssertNotNil(result)
        XCTAssertEqual(String(input), " \n ")
    }

    func test_no_match() {
        let text = String(" \n ")
        let idx = text.index(text.startIndex, offsetBy: 1)
        var input = text[idx...]
        let result: Void? = Parsers.lineStart.run(&input)

        XCTAssertNil(result)
        XCTAssertEqual(String(input), "\n ")
    }

}
