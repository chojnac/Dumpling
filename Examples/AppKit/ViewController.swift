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
        /// https://github.com/mxstbr/markdown-test-file/blob/master/TEST.md
        let testingURL = URL(string:  "https://raw.githubusercontent.com/mxstbr/markdown-test-file/master/TEST.md")!

        URLSession.shared.dataTask(with: testingURL) { [weak self] data, response, error in
            guard let data = data else {
                if let error = error {
                    print("Error: \(error)")

                }
                return
            }
            guard let content = String(data: data, encoding: .utf8) else {
                print("Invalid content, unable to create a string")
                return
            }
            DispatchQueue.main.async {
                let parser = Markdown()
                let ast = parser.parse(content)
                self?.show(html: ast.renderHTML())
                let string = ast.renderAttributedString()
                let storageSize = self?.textView.textStorage?.length ?? 0
                self?.textView.textStorage?.replaceCharacters(in: NSRange(location: 0, length: storageSize), with: string)
            }
        }.resume()
    }

    private func show(html: String) {
        webView.loadHTMLString(html, baseURL: nil)
    }

    @IBAction func changePreviewType(_ source: NSSegmentedControl) {
        webView.isHidden = source.selectedSegment == 0
        textView.enclosingScrollView?.isHidden = !webView.isHidden
    }
}

