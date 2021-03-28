//
//  ParserTests_Basic.swift
//  DumplingTests
//
//  Created by Wojciech Chojnacki on 01/12/2019.
//  Copyright © 2019 Wojciech Chojnacki. All rights reserved.
//

import Dumpling
import XCTest

final class ParserTests_Basic: XCTestCase {
    var parser: Markdown!

    override func setUp() {
        parser = Markdown()
    }

    func test__simple_case01() {
        let tc = "Lorem \n\n ipsum"
        let result = parser.parse(tc).debugString()
        XCTAssertEqual(result, "<p>Lorem</p><p>ipsum</p>")
    }
}
