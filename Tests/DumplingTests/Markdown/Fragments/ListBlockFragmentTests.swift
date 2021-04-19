//
//  ListBlockFragmentTests.swift
//  DumplingTests
//
//  Created by Wojciech Chojnacki on 12/03/2021.
//  Copyright © 2021 Wojciech Chojnacki. All rights reserved.
//

import XCTest
@testable import Dumpling

final class ListBlockFragmentTests: XCTestCase {
    var markdown: InlineMarkdown!

    override func setUp() {
        let config = Markdown.FragmentsConfig
            .default
            .mapBlockFragments {
                $0.filter({ $0.identifier != "list" })
            }
        markdown = InlineMarkdown(config)
    }

    func test_listParserRemovedFromMarkdown() {
        let input = "* Test"
        let result = markdown.parser.parse(input).debugString()
        XCTAssertEqual(result, "<p>*␣Test</p>")
    }

    func test_openingSequence() {
        var input = Reader("* Line 1 **bold**\n* Line 2")
        let result = ListBlockFragment.openingSequenceParser(identCount: 0).run(&input)
        XCTAssertEqual(result?.contentIdent, 2)
        XCTAssertEqual(input.string(), "Line 1 **bold**\n* Line 2")
    }

    func test_boldInLine1() {
        var input = Reader("* Line   1 **bold**\n* Line 2")

        let ast = ListBlockFragment.list(level: 0, identCount: 0, markdown: markdown, parentsOpenings: []).run(&input)
        let result = debug(ast)

        XCTAssertEqual(result, "<ul l=0><li>Line␣1␣<strong>bold</strong></li><li>Line␣2</li></ul>")
        XCTAssertEqual(input.string(), "")
    }

    func test_boldMultilined() {
        var input = Reader("* Line 1 **bold**\n* Line 2\n* Line 3")

        let ast = ListBlockFragment.list(level: 0, identCount: 0, markdown: markdown, parentsOpenings: []).run(&input)
        let result = debug(ast)

        XCTAssertEqual(result, "<ul l=0><li>Line␣1␣<strong>bold</strong></li><li>Line␣2</li><li>Line␣3</li></ul>")
        XCTAssertEqual(input.string(), "")
    }

    func test_linkInLine1() {
        var input = Reader("* Line 1 [name](/uri)\n* Line 2")

        let ast = ListBlockFragment.list(level: 0, identCount: 0, markdown: markdown, parentsOpenings: []).run(&input)
        let result = debug(ast)

        XCTAssertEqual(result, #"<ul l=0><li>Line␣1␣<link uri="/uri">name</link></li><li>Line␣2</li></ul>"#)
        XCTAssertEqual(input.string(), "")
    }

    func test_openingSequenceSpaceCounts() {
        var input = Reader(" *   Line 1 ")

        let result = ListBlockFragment.openingSequenceParser(identCount: 0).run(&input)

        XCTAssertEqual(result?.spacesCountPre, 1)
        XCTAssertEqual(result?.spacesCountPost, 3)
    }

    func debug(_ children: [ASTNode]) -> String {
        let root = AST.RootNode(children: children)
        return DebugTextRenderer().render(root)
    }

    func debug(_ child: AST.ListNode?) -> String? {
        guard let child = child else {
            return nil
        }
        let root = AST.RootNode(children: [child])
        return DebugTextRenderer().render(root)
    }
}
