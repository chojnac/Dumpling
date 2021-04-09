//
//  LocalParsers.swift
//  Dumpling
//
//  Created by Wojciech Chojnacki on 28/05/2020.
//  Copyright © 2020 Wojciech Chojnacki. All rights reserved.
//

import Foundation

extension Parsers {
    /// Single new line element
    public static let newLine: Parser<Void> = Parsers.one(character: "\n")
        .map { _ in () }
        .rename("newLine")

    public static let lineStart: Parser<Void> = .init("lineStart") { reader in
        guard !reader.isEmpty else { return nil }

        // start of the document
        if reader.base.startIndex == reader.startIndex {
            return ()
        }

        let prevIndex = reader.base.index(before: reader.startIndex)
        let ch = reader.base[prevIndex]

        guard ch == "\n" else {
            return nil
        }

        return ()
    }

    public static let lineEnd: Parser<Void> = Parsers.oneOf(Parsers.newLine, Parsers.isDocEnd)
    
    /// Match any single character
    public static let anyCharacter = Parser<Character>("anyCharacter") { reader in
        guard let ch = reader.popFirst() else {
            return nil
        }

        return ch
    }

    public static let singleEmptyLine = Parsers.oneOf(
            Parsers.zip(Parsers.zeroOrManySpaces, Parsers.newLine),
            Parsers.zip(Parsers.oneOrManySpaces, Parsers.isDocEnd)
    )

    /// Remove empty lines.
    /// The parser returns nil if there are no newlines removed or a number of lines removed
    public static let emptyLines = Parsers
        .minMax(parser: singleEmptyLine, min: 2)
        .map({$0.count - 1})
        .rename("emptyLines")

    public static let oneOrManySpaces = Parsers
        .minMax(parser: Parsers.space, min: 1)
        .map(\.count)
        .rename("oneOrMoreSpaces")

    public static let zeroOrManySpaces = Parsers
        .minMax(parser: Parsers.space, min: 0)
        .map(\.count)
        .rename("zeroOrManySpaces")

    public static func zeroOrManyCharacters(inSet set: CharacterSet) -> Parser<String> {
        Parsers.oneOf(
            Parsers.oneOrMany(Parsers.char(inSet: set)).map({ String($0) }),
            .just("")
        ).rename("zeroOrManyCharacters:\(set)")
    }

    public static let space: Parser<Void> = Parsers.one(character: " ")
        .mapToVoid
    
    public static func one(character: Character) -> Parser<Character> {
        .init("oneChacter:\(character)") { reader in
            let origin = reader
            guard let ch = reader.popFirst() else { return nil }

            guard ch == character else {
                reader = origin
                return nil
            }

            return character
        }
    }

    public static func min(character: Character, min: UInt = 1) -> Parser<Int> {
        return Parsers
            .minMax(parser: Parsers.one(character: character), min: min)
            .map(\.count)
            .rename("minChacter(\(min)):\(character)")
    }

    /// One or many
    public static func oneOrMany<T>(_ parser: Parser<T>) -> Parser<[T]> {
        Parsers.minMax(parser: parser, min: 1)
            .rename("oneOrMany")
    }

    public static func starts(with possiblePrefix: String) -> Parser<String> {
        .init("starts:'\(possiblePrefix)'") { reader in
            if reader.starts(with: possiblePrefix) {
                reader = reader.dropFirst(possiblePrefix.count)
                return possiblePrefix
            }

            return nil
        }
    }

    public static let isDocStart = Parser<Void>("isDocStart") { reader in
        guard !reader.isEmpty else { return nil }

        // start of the document
        guard reader.base.startIndex != reader.startIndex else {
            return ()
        }

        return nil
    }

    public static let isDocEnd = Parser<Void>("isDocEnd") { reader in
        guard !reader.isEmpty else { return () }
        return nil
    }

    public static func followedBy<T>(_ parser: Parser<T>) -> Parser<Void> {
        parser.lookAhead().mapToVoid.rename("followedBy: \(parser.name)")
    }

    public static func notFollowedBy<T>(_ parser: Parser<T>) -> Parser<Void> {
        return .init("notFollowedBy") { reader in
            let origin = reader
            if parser.run(&reader) != nil {
                reader = origin
                return nil
            }
            reader = origin
            return ()
        }
    }

    public static func char(inSet: CharacterSet) -> Parser<Character> {
        .init("charInSet:'\(inSet)'") { reader in

            guard !reader.isEmpty else { return nil }

            let origin = reader

            if let ch = reader.popFirst(),
                ch.unicodeScalars.allSatisfy(inSet.contains) {
                return ch
            }

            reader = origin
            return nil
        }
    }

}

extension Parsers {
    public static func not(_ parser: Parser<Void>) -> Parser<Void> {
        return .init("!\(parser.name)") { reader in
            let origin = reader
            if parser.run(&reader) != nil {
                reader = origin
                return nil
            }
            reader = origin
            return ()
        }
    }
}

extension Parsers {
    public static func intNumber() -> Parser<Int> {
        Parsers.minMax(parser: Parsers.char(inSet: .decimalDigits), min: 1, max: 9)
            .map {
                Int(String($0))
            }
            .flatMap({ $0.map(Parser.just) ?? .zero() })
            .rename("intNumber")
    }
}

extension Parsers {
    /// Process reader and build a string until stop happens.
    /// This parser fails only if there is no more data in the reader and the accumulated result is
    /// empty. When stop happens it returns string (it might be empty if stop succeed and the first
    /// character)
    /// -Parameters:
    ///  - stop: a parser that if succeed stops the execution and returns accumulated
    ///  characters as a string (can be empty). Stop parser is not consuming.
    /// - Returns: parser producing string or failing when parsing starts with the empty reader
    public static func stringUntil<P: ParserType>(stop: P) -> Parser<String> {
        return .init("stringUntil") { reader in
            let textBuffer = reader

            repeat {
                let readerBeforeCheck = reader
                if stop.run(&reader) != nil {
                    reader = readerBeforeCheck // stop is not consuming
                    let text = textBuffer[..<readerBeforeCheck.startIndex]
                    return String(text)
                }

                reader = reader.dropFirst()

                guard !reader.isEmpty else {
                    if textBuffer.isEmpty {
                        return nil
                    }
                    return String(textBuffer)
                }
            } while true
        }
    }
}
