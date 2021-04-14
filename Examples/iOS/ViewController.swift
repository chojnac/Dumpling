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

        let testingFilePath = Bundle.main.url(forResource: "text02.md", withExtension: nil)!
        let text = try! String(contentsOf: testingFilePath)

        let attributedStringRenderer = AttributedStringRenderer(theme: .default)

        attributedStringRenderer.registerRenderFragment(fragment: CustomListNodeRenderFragment())

        let parser = Markdown()
        let ast = parser.parse(text)
        self.show(html: ast.renderHTML())

        let string = ast.renderAttributedString()
        // uncomment to see use of the custom list indicator
        // let string = attributedStringRenderer.render(ast)
        self.textView.attributedText = string
    }

    private func show(html: String) {
        webView.loadHTMLString(html, baseURL: nil)
    }

    @IBAction func changePreviewType(_ source: UISegmentedControl) {
        webView.isHidden = source.selectedSegmentIndex == 0
        textView.isHidden = !webView.isHidden
    }
}

