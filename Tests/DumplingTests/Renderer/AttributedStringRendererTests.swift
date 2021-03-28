//
//  AttributedStringRendererTests.swift
//  Dumpling
//
//  Created by Wojciech Chojnacki on 21/03/2021.
//  Copyright © 2021 Dumpling. All rights reserved.
//

import XCTest
import Dumpling

final class AttributedStringRendererTests: XCTestCase {

    let renderer = AttributedStringRenderer(
        theme: .default
    )

    func testText() {
        let root = Markdown().parse("**Lorem** ipsum")
        let result = renderer.render(root)
        XCTAssertEqual(result.string, "Lorem ipsum\n")
    }

}
