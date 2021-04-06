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
        let codeParamsCharacterSet = CharacterSet.alphanumerics.union(CharacterSet.whitespaces)
        let codeParamsParser = Parsers.zip(
            Parsers.zeroOrManySpaces,
            Parsers.zeroOrManyCharacters(inSet: codeParamsCharacterSet),
            Parsers.zeroOrManySpaces
        ).map { $0.1 }

        // TODO: suppor opening/closing with more that 3 ` characters
        let opening = Parsers.zip(
            Parsers.lineStart,
            Parsers.zeroOrManySpaces,
            Parsers.starts(with: String(repeating: "`", count: 3)),
            // Parsers.min(character: "`", min: 3),
            codeParamsParser,
            Parsers.newLine
        ).map { _, _, _, params, _  in
            params
        }

        let closing = Parsers.zip(
            Parsers.newLine,
            Parsers.zeroOrManySpaces,
            Parsers.starts(with: String(repeating: "`", count: 3)),
            Parsers.zeroOrManySpaces,
            Parsers.oneOf(Parsers.newLine, Parsers.isDocEnd)
        )

        let parser = opening.flatMap { params in
            Parsers.zip(
                Parser<String>.just(params),
                Parsers.repeatUntil(Parsers.anyCharacter, stop: closing)
                    .flatMap {
                        $0.stop == nil ? .zero() : .just(String($0.accumulator))
                    }

            )
        }.map { params, body in
            (params: params, body: body)
        }.map {
            AST.CodeNode(params: $0.params, body: $0.body, isBlock: true)
        }

        return parser
    }
}
