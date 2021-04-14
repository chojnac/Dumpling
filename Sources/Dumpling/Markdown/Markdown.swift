//
//  NewMarkdown.swift
//  Dumpling
//
//  Created by Wojciech Chojnacki on 29/05/2020.
//  Copyright © 2020 Wojciech Chojnacki. All rights reserved.
//

import Foundation

public protocol MarkdownType {
    func inline(
        exitParser: Parser<Void>,
        preExitCheckParser: Parser<Void>?
    ) -> Parser<[ASTNode]>

    func block(_ string: String) -> [ASTNode]
}

public final class Markdown {
    /// Helper for hiding Markdown::inline function from the public interface
    private struct InlineMarkdown: MarkdownType {
        let markdown: Markdown
        func inline(exitParser: Parser<Void>, preExitCheckParser: Parser<Void>?) -> Parser<[ASTNode]> {
            markdown.inline(
                exitParser: exitParser,
                preExitCheckParser: preExitCheckParser
            )
        }

        func block(_ string: String) -> [ASTNode] {
            return markdown.block(string)
        }
    }

    private var inlineElementsParser: Parser<ASTNode> = .zero()
    private var blockElementsParser: Parser<ASTNode> = .zero()

    public init(_ config: FragmentsConfig = .default) {
        let inlineMarkdown = InlineMarkdown(markdown: self)
        inlineElementsParser = config.inlineParser(markdown: inlineMarkdown)
        blockElementsParser = config.blockParser(markdown: inlineMarkdown)
    }

    func inline(
        exitParser: Parser<Void>,
        preExitCheckParser: Parser<Void>? = nil
    ) -> Parser<[ASTNode]> {
        return .init("inline") { reader in
            guard !reader.isEmpty else {
                return nil
            }
            let preExitCheck = (preExitCheckParser ?? Parsers.emptyLines.mapToVoid).lookAhead()
            let exit = exitParser.lookAhead()

            let contentExit = Parsers.oneOf(
                exit,
                self.inlineElementsParser.mapToVoid
            )

            let content = Parsers.stringUntil(stop: contentExit.lookAhead())

            var children = [ASTNode]()

            repeat {

                guard preExitCheck.run(&reader) == nil else {
                    break
                }

                if let result = self.inlineElementsParser.run(&reader) {
                    children.append(result)
                    continue
                }

                guard exit.run(&reader) == nil else {
                    break
                }

                if let text = content.run(&reader) {
                    children.append(AST.TextNode(text))
                    continue
                }

                guard !reader.isEmpty else {
                    break
                }

            } while true

            if children.isEmpty {
                return nil
            }

            return children
        }
    }

    func parser() -> Parser<AST.RootNode> {
        let stopParser = blockElementsParser

        return .init("markdown") { reader in
            var children = [ASTNode]()

            while !reader.isEmpty {
                if Parsers.newLine.run(&reader) != nil {
                    continue
                }

                if let result = self.inline(
                        exitParser: .zero(),
                        preExitCheckParser: stopParser.mapToVoid
                    ).run(&reader) {
                    children.append(AST.ParagraphNode(children: result))
                }

                if let result = self.blockElementsParser.run(&reader) {
                    if result is AST.ParagraphNode {
                        continue
                    }
                    children.append(result)
                    continue
                }

                break
            }

            return AST.RootNode(children: children)
        }
    }

    func block(_ string: String) -> [ASTNode] {
        var reader = string[...]
        return parser().run(&reader)?.children ?? []
    }
    public func parse(_ string: String) -> AST.RootNode {
        var reader = string[...]
        return parser().run(&reader) ?? AST.RootNode(children: [])
    }
}
