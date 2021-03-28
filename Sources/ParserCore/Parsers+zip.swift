//
//  Parsers+zip.swift
//  ParserCore
//
//  Created by Wojciech Chojnacki on 28/05/2020.
//  Copyright © 2020 Wojciech Chojnacki. All rights reserved.
//

import Foundation

extension Parsers {
    public static func zip<A: ParserType, B: ParserType>(
        _ p1: A,
        _ p2: B
    ) -> Parser<(A.Element, B.Element)> {
        AnyZipParser(
            "zip[\(p1.name),\(p2.name)]",
            parsers: [
                p1.anyParser(),
                p2.anyParser()
            ]
        )
        .map {
            (
                $0[0] as! A.Element,
                $0[1] as! B.Element
            )
        }
    }
    
    public static func zip<A: ParserType, B: ParserType, C: ParserType>(
        _ p1: A,
        _ p2: B,
        _ p3: C
    ) -> Parser<(A.Element, B.Element, C.Element)> {
        AnyZipParser(
            "zip[\(p1.name),\(p2.name),\(p3.name)]",
            parsers: [
                p1.anyParser(),
                p2.anyParser(),
                p3.anyParser()
            ]
        )
        .map {
            (
                $0[0] as! A.Element,
                $0[1] as! B.Element,
                $0[2] as! C.Element
            )
        }
    }
    
    public static func zip<A: ParserType, B: ParserType, C: ParserType, D: ParserType>(
        _ p1: A,
        _ p2: B,
        _ p3: C,
        _ p4: D,
        debugPrefix: String? = nil
    ) -> Parser<(A.Element, B.Element, C.Element, D.Element)> {
        
        AnyZipParser(
            "zip[\(p1.name),\(p2.name),\(p3.name),\(p4.name)]",
            debugPrefix: debugPrefix,
            parsers: [
                p1.anyParser(),
                p2.anyParser(),
                p3.anyParser(),
                p4.anyParser()
            ]
        )
        .map {
            (
                $0[0] as! A.Element,
                $0[1] as! B.Element,
                $0[2] as! C.Element,
                $0[3] as! D.Element
            )
        }
    }

    public static func zip<A: ParserType, B: ParserType, C: ParserType, D: ParserType, E: ParserType>(
        _ p1: A,
        _ p2: B,
        _ p3: C,
        _ p4: D,
        _ p5: E,
        debugPrefix: String? = nil
    ) -> Parser<(A.Element, B.Element, C.Element, D.Element, E.Element)> {

        AnyZipParser(
            "zip[\(p1.name),\(p2.name),\(p3.name),\(p4.name),\(p5.name)]",
            debugPrefix: debugPrefix,
            parsers: [
                p1.anyParser(),
                p2.anyParser(),
                p3.anyParser(),
                p4.anyParser(),
                p5.anyParser()
            ]
        )
        .map {
            (
                $0[0] as! A.Element,
                $0[1] as! B.Element,
                $0[2] as! C.Element,
                $0[3] as! D.Element,
                $0[4] as! E.Element
            )
        }
    }

    public static func zip<A: ParserType, B: ParserType, C: ParserType, D: ParserType, E: ParserType, F: ParserType>(
        _ p1: A,
        _ p2: B,
        _ p3: C,
        _ p4: D,
        _ p5: E,
        _ p6: F,
        debugPrefix: String? = nil
    ) -> Parser<(A.Element, B.Element, C.Element, D.Element, E.Element, F.Element)> {

        AnyZipParser(
            "zip[\(p1.name),\(p2.name),\(p3.name),\(p4.name),\(p5.name)]",
            debugPrefix: debugPrefix,
            parsers: [
                p1.anyParser(),
                p2.anyParser(),
                p3.anyParser(),
                p4.anyParser(),
                p5.anyParser(),
                p6.anyParser()
            ]
        )
        .map {
            (
                $0[0] as! A.Element,
                $0[1] as! B.Element,
                $0[2] as! C.Element,
                $0[3] as! D.Element,
                $0[4] as! E.Element,
                $0[5] as! F.Element
            )
        }
    }
}

struct AnyZipParser: ParserType {
    public let name: String
    private let debugPrefix: String?
    private let parsers: [Parser<Any>]
    
    public init(_ name: String, debugPrefix: String? = nil, parsers: [Parser<Any>]) {
        self.name = name
        self.parsers = debugPrefix != nil ? parsers.enumerated().map { $0.element
            .debug(debugPrefix!+"[\($0.offset), \($0.element.name)]") } : parsers
        self.debugPrefix = debugPrefix
    }

    public func run(_ reader: inout Reader) -> [Any]? {
        let origin = reader
        var results = [Any]()
        for parser in parsers {
            guard let result = parser.run(&reader) else {
                reader = origin
                return nil
            }
            results.append(result)
        }

        return results
    }
}

extension ParserType {
    func anyParser() -> Parser<Any> {
        return map {
            $0
        }
    }
}
