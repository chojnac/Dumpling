//
//  CodeSpanInlineFragment.swift
//  Dumpling
//
//  Created by Wojciech Chojnacki on 30/05/2020.
//  Copyright © 2020 Wojciech Chojnacki. All rights reserved.
//

import Foundation

public struct CodeSpanInlineFragment: MarkdownInlineFragment {
    public let identifier: String = "codeSpan"

    public init() {}

    public func build(markdown: MarkdownType) -> Parser<AST.CodeNode> {
        let open = Parsers.oneOrMany(Parsers.one(character: "`"))

        return .init("code") { reader in
            let origin = reader
            guard let starts = open.run(&reader) else {
                reader = origin
                return nil
            }
            let close = Parsers.starts(with: String(starts)).mapToVoid

            _ = Parsers.oneOrManySpaces.run(&reader)

            var content = [String]()

            let contentExit = Parsers.oneOf(
                Parsers.newLine,
                close,
                Parsers.space
            )

            let contentParser = Parsers.stringUntil(stop: contentExit.lookAhead())

            while !reader.isEmpty {
                if let text = contentParser.run(&reader), !text.isEmpty {
                    content.append(text)
                    continue
                }

                if Parsers.newLine.lookAhead().run(&reader) != nil {
                    if Parsers.emptyLines.lookAhead().run(&reader) != nil {
                        break
                    }
                    reader = reader.dropFirst()
                    content.append(" ")
                    _ = Parsers.oneOrManySpaces.run(&reader)
                }

                if Parsers.space.run(&reader) != nil {
                    _ = Parsers.oneOrManySpaces.run(&reader)
                    content.append(" ")
                }

                if close.run(&reader) != nil {
                    if let last = content.last, last == " " {
                        content = content.dropLast()
                    }
                    return AST.CodeNode(params: nil, body: content.joined(), isBlock: false)
                }
            }
            reader = origin
            return nil
        }
    }
}
