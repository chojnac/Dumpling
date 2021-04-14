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

        let testingFilePath = Bundle.main.url(forResource: "text02.md", withExtension: nil)!
        let text = try! String(contentsOf: testingFilePath)

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
}

