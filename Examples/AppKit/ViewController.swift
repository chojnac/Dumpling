//
//  ViewController.swift
//  Example-AppKit
//
//  Created by Wojciech Chojnacki on 10/03/2021.
//  Copyright © 2021 Wojciech Chojnacki. All rights reserved.
//

import Cocoa
import WebKit
import Dumpling

final class ViewController: NSViewController {
    @IBOutlet var webView: WKWebView!
    @IBOutlet var textView: NSTextView!
    @IBOutlet var typeSelection: NSSegmentedControl!

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        changePreviewType(typeSelection)

        let text: String

        if let fileURL = fileFromCommandlineArgument() {
            print("Open file from: \(fileURL)")
            let data = try! Data(contentsOf: fileURL)
            text = String(decoding: data, as: UTF8.self)
        } else {
            let testingFilePath = Bundle.main.url(forResource: "text02.md", withExtension: nil)!
            text = try! String(contentsOf: testingFilePath)
        }

        let parser = Markdown()
        let ast = parser.parse(text)
        self.show(html: ast.renderHTML())
        let string = ast.renderAttributedString()
        let storageSize = textView.textStorage?.length ?? 0
        self.textView.textStorage?.replaceCharacters(in: NSRange(location: 0, length: storageSize), with: string)
    }

    private func show(html: String) {
        webView.loadHTMLString(html, baseURL: nil)
    }

    @IBAction func changePreviewType(_ source: NSSegmentedControl) {
        webView.isHidden = source.selectedSegment == 0
        textView.enclosingScrollView?.isHidden = !webView.isHidden
    }

    private func fileFromCommandlineArgument() -> URL? {
        // remove arguments from the Xcode
        let arguments = CommandLine.arguments.dropFirst()
            .filter {
                !$0.hasPrefix("-") &&
                $0 != "YES"
            }

        guard let filePath = arguments.first else { return nil }

        let fileURL: URL

        if filePath.hasPrefix("/") {
            fileURL = URL(fileURLWithPath: filePath, isDirectory: false)
        } else if filePath.starts(with: "~") {
            let path = NSString(string: filePath).expandingTildeInPath
            fileURL = URL(fileURLWithPath: path, isDirectory: false)
        } else {
            let directory = FileManager.default.currentDirectoryPath
            let directoryURL = URL(fileURLWithPath: directory, isDirectory: true)
            fileURL = directoryURL.appendingPathComponent(filePath)
        }

        return fileURL
    }
}

