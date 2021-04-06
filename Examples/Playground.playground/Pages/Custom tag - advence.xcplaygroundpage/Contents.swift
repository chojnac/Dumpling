//: [Previous](@previous)

import Foundation
import UIKit
import Dumpling

public struct AST {
    struct FillTheGapNode: ASTNode {
        public let children: [ASTNode]
        public let charactersCount: Int

        public init(charactersCount: Int) {
            self.children = []
            self.charactersCount = charactersCount
        }
    }
}

/**
 New tag %%_{1,n}%%%, for example %%___%%
 */
struct FillTheGapInlineFragment: MarkdownInlineFragment {
    let identifier: String = "fillTheGap"

    func build(markdown: MarkdownType) -> Parser<AST.FillTheGapNode> {
        let opening = Parsers.starts(with: "%%")
        let closing = opening
        return Parsers.zip(
            opening,
            Parsers.oneOrMany(Parsers.one(character: "_")),
            closing
        ).map { _, characters, _ in
            AST.FillTheGapNode(charactersCount: characters.count)
        }
    }
}

struct FillTheGapNodeRenderFragment: AttributedStringRenderFragment {
    public func render(
        _ node: AST.FillTheGapNode,
        context: AttributedStringRenderer.Context,
        renderer: AttributedStringContentRenderer
    ) -> NSAttributedString? {
        var attributes = context.parentAttributes
        attributes[.fillTheGap] = "1"
        attributes[.font] = UIFont.monospacedSystemFont(ofSize: 17, weight: .regular)
        return NSAttributedString(
            string: " " + String(repeating: "⎵", count: node.charactersCount) + " ",
            attributes: attributes
        )
    }
}

let config = zip(
    Markdown.FragmentsConfig(inline: [FillTheGapInlineFragment().any()], block: []),
    Markdown.FragmentsConfig.default
)
let markdown = Markdown(config)

let theme = AttributedStringTheme.default
let renderer = AttributedStringRenderer(theme: theme)
renderer.registerRenderFragment(fragment: FillTheGapNodeRenderFragment())

let ast = markdown.parse(textCustomTag)
let string = renderer.render(ast)
//: [Next](@next)
