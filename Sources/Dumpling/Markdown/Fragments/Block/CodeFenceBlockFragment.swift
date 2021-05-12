//
//  CodeFenceInlineFragment.swift
//  Dumpling
//
//  Created by Wojciech Chojnacki on 10/03/2021.
//  Copyright © 2021 Wojciech Chojnacki. All rights reserved.
//

import Foundation

public struct CodeFenceBlockFragment: MarkdownBlockFragment {
    public let identifier: String = "codeFenc"

    public init() {}
    
    public func build(markdown: MarkdownType) -> Parser<AST.CodeNode> {

        let codeParamsParser = Parsers.repeatUntil(Parsers.anyCharacter, stop: Parsers.lineEnd)
            .map {
                String($0.accumulator).trimmingCharacters(in: .whitespaces)
            }

        // TODO: support opening/closing with more that 3 ` characters
        let opening = Parsers.zip(
            Parsers.lineStart,
            Parsers.zeroOrManySpaces,
            Parsers.minMax(parser: Parsers.one(character: "`"), min: 3),
            codeParamsParser
        ).map { _, _, fence, params  in
            (fence: fence, params: params)
        }

        func closing(opening: [Character]) -> Parser<Void> {
            return Parsers.oneOf(
                Parsers.isDocEnd,
                Parsers.zip(
                    Parsers.newLine,
                    Parsers.zeroOrManySpaces,
                    Parsers.min(character: opening[0], min: UInt(opening.count)),
                    Parsers.zeroOrManySpaces,
                    Parsers.lineEnd
                ).mapToVoid
            )
        }

        let parser = opening
            .flatMap { result -> Parser<(String, String)> in
                let closing = closing(opening: result.fence)
                return Parsers.zip(
                    Parser<String>.just(result.params),
                    Parsers.repeatUntil(Parsers.anyCharacter, stop: closing)
                        .flatMap {
                            $0.stop == nil ? .zero() : .just(String($0.accumulator))
                        }
                )
            }.map {
                AST.CodeNode(params: $0.0, body: $0.1, isBlock: true)
            }

        return parser
    }
}
