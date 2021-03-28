//
//  ViewController.swift
//  Example-iOS
//
//  Created by Wojciech Chojnacki on 10/03/2021.
//  Copyright © 2021 Wojciech Chojnacki. All rights reserved.
//

import UIKit
import Dumpling
import WebKit

class CustomListNodeRenderFragment: ListNodeRenderFragment {

    override func indicator(node: AST.ListNode, position: Int) -> Indicator {
        if case .bullet = node.kind {
            return .string("→  ")
        }

        return super.indicator(node: node, position: position)
    }
}

final class ViewController: UIViewController {
    @IBOutlet var webView: WKWebView!
    @IBOutlet var textView: UITextView!
    @IBOutlet var typeSelection: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        changePreviewType(typeSelection)
        /// https://github.com/mxstbr/markdown-test-file/blob/master/TEST.md
        let testingURL = URL(string:  "https://raw.githubusercontent.com/mxstbr/markdown-test-file/master/TEST.md")!

        let attributedStringRenderer = AttributedStringRenderer(theme: .default)

        attributedStringRenderer.registerRenderFragment(fragment: CustomListNodeRenderFragment())
        
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
                // uncomment to see use list indicator
                // let string = attributedStringRenderer.render(ast)
                self?.textView.attributedText = string
            }
        }.resume()
    }

    private func show(html: String) {
        webView.loadHTMLString(html, baseURL: nil)
    }

    @IBAction func changePreviewType(_ source: UISegmentedControl) {
        webView.isHidden = source.selectedSegmentIndex == 0
        textView.isHidden = !webView.isHidden
    }
}

