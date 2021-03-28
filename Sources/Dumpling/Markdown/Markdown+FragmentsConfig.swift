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
        public let inline: [AnyMarkdownInlineFragment]
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
                EscapeInlineFragment().any(),
                CodeFenceInlineFragment().any(),
                CodeSpanInlineFragment().any(),
                LinkInlineFragment().any(),
                EnclosedInlineFragment(id: "s", str: "~~").any(),
                EnclosedInlineFragment(id: "strong", str: "**").any(),
                EnclosedInlineFragment(id: "strong", str: "__").any(),
                EnclosedInlineFragment(id: "em", str: "*").any(),
                EnclosedInlineFragment(id: "em", str: "_").any()
            ],
            block: [
                HeaderBlockFragment().any(),
                ListBlockFragment().any(),
                ParaBlockFragment().any()
            ]
        ),
        .base
    )
}
