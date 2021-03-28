//
//  Parsers.swift
//  Dumpling
//
//  Created by Wojciech Chojnacki on 30/11/2019.
//  Copyright © 2019 Wojciech Chojnacki. All rights reserved.
//

import Foundation

public enum Parsers {


    /// Execute parsers until the first one returns a result or fail if none of them is successful
    ///
    /// - Parameter parsers: parsers to execute
    /// - Returns: result of the first successful parser
    public static func oneOf<T: ParserType>(_ parsers: T ...) -> Parser<T.Element> {
        oneOf(parsers)
    }

    /// Execute parsers until the first one returns a result or fail if none of them is successful
    ///
    /// - Parameter parsers: parsers to execute
    /// - Returns: result of the first successful parser
    public static func oneOf<T: ParserType, C: RandomAccessCollection>(_ parsers: C)
        -> Parser<T.Element> where C.Element == T {
            let names = parsers.map { $0.name }.joined(separator: ",")
            return Parser("oneOf[\(names)]") { reader -> T.Element? in
            for parser in parsers {
                if let result = parser.run(&reader) {
                    return result
                }
            }

            return nil
        }
    }

    /// Repeat execution of the first parser and accumulate its result in an array.
    /// Execution stops when parser `stop` succeed or there is no more data in the reader.
    ///
    /// This parser fails only if the reader and accumulator are empty.
    ///
    /// There are 3 cases when this parser finishes work:
    /// 1. check parser fails to match
    /// 2. there is a match with the stop parser
    /// 3. there are no more character in the reader to process further
    ///
    /// - Parameters:
    ///  - check: parser executed in the loop producing data
    ///  - stop: consuming parser which stops the loop
    /// - Returns: a tuple of accumulated results from the `check` parser and the result of
    /// stop parser (content is match succeed or nil if loop finished from other reasons)
    public static func repeatUntil<P1: ParserType, P2: ParserType>(_ check: P1, stop: P2) -> Parser<(accumulator: [P1.Element], stop: P2.Element?)> {
        return Parser("parseUntil[\(check.name) stop=\(stop.name)]") { reader in
            var accumulator: [P1.Element] = []

            repeat {
                guard !reader.isEmpty else {
                    if accumulator.isEmpty {
                        return nil
                    }
                    return (accumulator, nil)
                }

                if let stopValue = stop.run(&reader) {
                    return (accumulator, stopValue)
                }

                if let parserValue = check.run(&reader) {
                    accumulator.append(parserValue)
                    continue
                }

                return (accumulator, nil)
            } while true
        }
    }
}

