//
//  EmphasisInlineFragment.swift
//  Dumpling
//
//  Created by Wojciech Chojnacki on 11/04/2021.
//  Copyright © 2021 Dumpling. All rights reserved.
//

import Foundation

public struct EmphasisInlineFragment: MarkdownInlineFragment {
    public let identifier: String = "emphasis"

    public enum Kind {
        case normal
        case strong
    }
    private let punctuaction = Parsers.char(inSet: CharacterSet.init(charactersIn: "!\"#$%&'()*+,-./:;<=>?@[]^_`{|}~"))
    private let delimiterParser: Parser<Character>
    private let kind: Kind

    private let specialSpace = Parsers.oneOf(
        Parsers.space,
        Parsers.lineEnd,
        Parsers.lineStart
    )

    private let precededBySpecialSpace = Parsers.oneOf(
        EmphasisCheckPreceded(forParser: Parsers.space).mapToVoid,
        Parsers.lineEnd,
        Parsers.lineStart
    )

    private let precededByPunctuation: Parser<Void>

    init(kind: Kind) {
        switch kind {
        case .normal:
            delimiterParser = Parsers.oneOf(
                Parsers.one(character: "_"),
                Parsers.one(character: "*")
            )
        case .strong:
            delimiterParser = Parsers.oneOf(
                Parsers.starts(with: "__"),
                Parsers.starts(with: "**")
            ).map { $0.first! }
        }
        self.kind = kind

        precededByPunctuation = EmphasisCheckPreceded(forParser: punctuaction).mapToVoid
    }

    private func leftFlankyChecks(step: EmphasisDelimterRunParser.Step) -> Parser<Character> {
        // 1. not followed by Unicode whitespace
        let check1 = step.check(
            beginingParser: .just(()),
            endParser: Parsers.not(specialSpace)
        )
        // 2a. not followed by a punctuation character
        let check2a = step.check(
            beginingParser: .just(()),
            endParser: Parsers.not(punctuaction.mapToVoid)
        )
        // 2b. followed by a punctuation character and preceded by Unicode
        // whitespace or a punctuation character.
        let check2b = step.check(
            beginingParser: Parsers.oneOf(
                precededByPunctuation,
                precededBySpecialSpace
            ),
            endParser: punctuaction
        )

        return Parsers.zip(
            check1,
            Parsers.oneOf(check2a, check2b)
        ).map(\.0)
    }

    private func rightFlankyChecks(step: EmphasisDelimterRunParser.Step) -> Parser<Character> {
        // 1. not preceded by Unicode whitespace
        let check1 = step.check(
            beginingParser: Parsers.not(precededBySpecialSpace),
            endParser: .just(())
        )

        // 2a. not preceded by a punctuation character
        let check2a = step.check(
            beginingParser: Parsers.not(precededByPunctuation),
            endParser: .just(())
        )

        // 2b. preceded by a punctuation character and followed by Unicode whitespace or a punctuation character.
        let check2b = step.check(
            beginingParser: precededByPunctuation.mapToVoid,
            endParser: Parsers.oneOf(punctuaction.mapToVoid, specialSpace)
        )

        return Parsers.zip(
            check1,
            Parsers.oneOf(check2a, check2b)
        ).map(\.0)
    }

    typealias DelimiterCheckResult = (isLeftFlanky: Bool, isRightFlanky: Bool, delimiter: Character)

    func baseDelimiterCheck() -> Parser<(step: EmphasisDelimterRunParser.Step, check: DelimiterCheckResult)> {
        EmphasisDelimterRunParser().flatMap { step in
            Parsers.zip(
                Parsers.oneOf(leftFlankyChecks(step: step).mapTo(true), .just(false)),
                Parsers.oneOf(rightFlankyChecks(step: step).mapTo(true), .just(false))
            ).map { isLeftFlanky, isRightFlanky in
                (
                    step: step,
                    check: (
                        isLeftFlanky: isLeftFlanky,
                        isRightFlanky: isRightFlanky,
                        delimiter: step.character
                    )
                )
            }
        }
    }

    func delimiterCheck(isOpening: Bool) -> Parser<DelimiterCheckResult> {
        baseDelimiterCheck().flatMap { step, check in
            if isOpening, !check.isLeftFlanky {
                return .zero()
            }
            
            if !isOpening, !check.isRightFlanky {
                return .zero()
            }
            
            if check.delimiter == "_" {
                if isOpening {
                    if check.isRightFlanky {
                        return step.check(
                            beginingParser: precededByPunctuation,
                            endParser: .just(())
                        ).mapTo(check)
                    }
                } else {
                    if check.isLeftFlanky {
                        // part of a left-flanking delimiter run followed by punctuation.
                        return step.check(
                            beginingParser: .just(()),
                            endParser: punctuaction
                        ).mapTo(check)
                    }
                }
            }
            
            return .just(check)
        }
    }

    public func build(markdown: MarkdownType) -> Parser<AST.StyleNode> {

        let openingParser = delimiterCheck(isOpening: true)
            .flatMap { _ in delimiterParser }

        let genericClosingParser = delimiterCheck(isOpening: false)
            .flatMap { _ in delimiterParser }

        return .init(identifier) { reader in
            let origin = reader
            guard let openingDelimiter = openingParser.run(&reader) else {
                return nil
            }

            let closingParser = genericClosingParser
                .flatMap {
                    $0 == openingDelimiter ? .just($0) : .zero()
                }

            guard let content = markdown.inline(
                exitParser: closingParser.mapToVoid,
                preExitCheckParser: nil
            ).run(&reader), !content.isEmpty else {
                reader = origin
                return nil
            }

            guard closingParser.run(&reader) != nil else {
                reader = origin
                return nil
            }

            switch kind {
            case .normal:
                return AST.StyleNode(id: "em", children: content)
            case .strong:
                return AST.StyleNode(id: "strong", children: content)
            }

        }
    }
}

/// Move the current reader one character back and run parser for the new reader.
/// Original reader isn't changed. 
struct EmphasisCheckPreceded<T>: ParserType {
    let name = "checkPreceded"
    let k: UInt
    let parser: Parser<T>

    init(_ k: UInt = 1, forParser parser: Parser<T>) {
        self.parser = parser
        self.k = k
    }

    func run(_ reader: inout Reader) -> T? {
        let newStartIndex = reader.base.index(
            reader.startIndex,
            offsetBy: -Int(k),
            limitedBy: reader.base.startIndex
        ) ?? reader.base.startIndex
        var newReader = reader.sub(newStartIndex, reader.endIndex)
        return parser.run(&newReader)
    }
}

/// Extract delimiter (continuous block of `_` or `*` characters) by moving forward & backwards on the current reader.
/// Original reader isn't changed.
/// The result of this parser is a structure containing delimiter character and two `Readers`, one for a substring
/// starting at the beginning of the delimiter and another one on the first character after the block. 
struct EmphasisDelimterRunParser: ParserType {
    let name = "delimiterRun"

    func run(_ reader: inout Reader) -> Step? {
        var count = 0
        let origin = reader
        var lhsReader = reader

        guard let delimiter = reader.first,
              delimiter == "_" || delimiter == "*"
        else {
            return nil
        }
        
        reader = reader.dropFirst()
        count += 1

        // rhs run

        repeat {
            guard let character = reader.first else {
                break
            }

            guard character == delimiter else {
                break
            }

            reader = reader.dropFirst()

            count += 1
        } while true

        // lhs past run

        repeat {
            guard let newStartIndex = lhsReader.base.index(
                lhsReader.startIndex,
                offsetBy: -1,
                limitedBy: lhsReader.base.startIndex
            ) else {
                break
            }
            lhsReader = lhsReader.sub(newStartIndex, lhsReader.endIndex)
            guard let character = lhsReader.first else {
                break
            }

            guard character == delimiter else {
                lhsReader = lhsReader.dropFirst()
                break
            }
            count += 1
        } while true

        guard count > 0 else {
            reader = origin
            return nil
        }

        let rhsReader = reader
        reader = origin

        return .init(character: delimiter, count: count, lhsReader: lhsReader, rhsReader: rhsReader)
    }

    struct Step {
        let character: Character
        let count: Int
        let lhsReader: Reader
        let rhsReader: Reader

        func check<R1, R2>(beginingParser: Parser<R1>, endParser: Parser<R2>) -> Parser<Character> {
            return .init("check") { _ in
                var readerL = lhsReader
                var readerR = rhsReader

                guard beginingParser.run(&readerL) != nil else {
                    return nil
                }

                guard endParser.run(&readerR) != nil else {
                    return nil
                }

                return character
            }
        }
    }
}

extension EmphasisInlineFragment {
    public struct Fragment: MarkdownInlineFragment {
        public let identifier: String

        public func build(markdown: MarkdownType) -> Parser<AST.StyleNode> {
            Parsers.oneOf(
                EmphasisInlineFragment(kind: .strong).build(markdown: markdown),
                EmphasisInlineFragment(kind: .normal).build(markdown: markdown)
            )
        }
    }

    public static func instance() -> EmphasisInlineFragment.Fragment {
        return .init(identifier: "emphasis")
    }
}
