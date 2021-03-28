//
//  HTMLRendererTests.swift
//  DumplingTests
//
//  Created by Wojciech Chojnacki on 12/12/2019.
//  Copyright © 2019 Wojciech Chojnacki. All rights reserved.
//

import XCTest
import Dumpling

final class HTMLRendererTests: XCTestCase {

    func testText() {
        let textNode = AST.TextNode("Lorem<em>ipsum \"&</em>")
        let result = AST.RootNode(children: [textNode]).renderHTML()
        
        XCTAssertEqual(result, "Lorem&lt;em&gt;ipsum &quot;&amp;&lt;/em&gt;")
    }

}
