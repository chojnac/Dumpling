//
//  Markdown+FragmentConfig.swift
//  Dumpling
//
//  Created by Wojciech Chojnacki on 27/03/2021.
//  Copyright © 2021 Dumpling. All rights reserved.
//

import Foundation

extension Markdown {
    public struct FragmentsConfig {
        /// Inline elements, order in this array defines precedence
        public let inline: [AnyMarkdownInlineFragment]
        /// Block elements, order in this array defines precedence (first is winning)
        public let block: [AnyMarkdownBlockFragment]

        public init(inline: [AnyMarkdownInlineFragment], block: [AnyMarkdownBlockFragment]) {
            self.inline = inline
            self.block = block
        }

        func inlineParser(markdown: MarkdownType) -> Parser<ASTNode> {
            let parsers = inline.map {
                $0.build(markdown: markdown)
            }
            return Parsers.oneOf(parsers)
        }

        func blockParser(markdown: MarkdownType) -> Parser<ASTNode> {
            let parsers = block.map {
                $0.build(markdown: markdown)
            }
            return Parsers.oneOf(parsers)
        }

        public func mapInlineFragments(
            _ transform: @escaping ([AnyMarkdownInlineFragment]) -> [AnyMarkdownInlineFragment]
        ) -> Self {
            let inline = transform(self.inline)
            return .init(inline: inline, block: block)
        }

        public func mapBlockFragments(
            _ transform: @escaping ([AnyMarkdownBlockFragment]) -> [AnyMarkdownBlockFragment]
        ) -> Self {
            let block = transform(self.block)
            return .init(inline: inline, block: block)
        }
    }
}

public func zip(_ lhs: Markdown.FragmentsConfig, _ rhs: Markdown.FragmentsConfig) -> Markdown.FragmentsConfig {
    return .init(
        inline: lhs.inline + rhs.inline,
        block: lhs.block + rhs.block
    )
}

extension Markdown.FragmentsConfig {
    public static let base: Self = .init(
        inline: [
            EscapeInlineFragment().any(),
            SpaceInlineFragment().any(),
            NewLineInlineFragment().any()
        ],
        block: [
            EOFBlockFragment().any()
        ]
    )
    public static let `default`: Self = zip(
        .init(
            inline: [
                CodeSpanInlineFragment().any(),
                LinkInlineFragment().any(),
                StrikethroughInlineFragment().any(),
                EmphasisInlineFragment.instance().any(),
            ],
            block: [
                HorizontalLineBlockFragment().any(), // take precedence over list
                HeaderBlockFragment().any(),
                ListBlockFragment().any(),
                CodeFenceBlockFragment().any(),
                ParaBlockFragment().any(),
            ]
        ),
        .base
    )
}
