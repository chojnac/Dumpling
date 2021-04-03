//
//  IntegrationTests.swift
//  
//
//  Created by Wojciech Chojnacki on 30/03/2021.
//

import Foundation
import Dumpling
import Helpers
import SnapshotTesting
import XCTest

final class IntegrationTests: XCTestCase {
    func testText01() {
        performTest(fileName: "text01.md", testName: #function)
    }

    func testText02() {
        performTest(fileName: "text02.md", testName: #function)
    }

    private func performTest(fileName: String, testName: String, file: StaticString = #filePath, line: UInt = #line) {
        guard let text = try? loadMarkdow(filename: fileName) else {
            XCTFail("Missing text file")
            return
        }

        #if canImport(AppKit)
        let system = "MacOS"
        #elseif canImport(UIKit)
        let system = "iOS"
        #endif
        let ast = Markdown().parse(text)

        #if canImport(AppKit) || canImport(UIKit)
        let string = ast.renderAttributedString()
        guard let image = string.toImage(width: 750) else {
            XCTFail("Missing image")
            return
        }
        assertSnapshot(matching: image, as: .image, testName: "\(testName)img-\(system)")
        #endif
        
        let html = ast.renderHTML()
        assertSnapshot(matching: html, as: .lines, testName: "\(testName)html")
    }

    private func loadMarkdow(filename: String, file: StaticString = #filePath, line: UInt = #line) throws -> String? {
        guard
            let url = Bundle.module.url(forResource: filename, withExtension: nil),
            let text = try? String(contentsOf: url) else {
            return nil
        }

        return text
    }
}
