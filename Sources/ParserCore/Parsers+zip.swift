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
        Zip2(p1: p1, p2: p2).asParser()
    }
    
    public static func zip<A: ParserType, B: ParserType, C: ParserType>(
        _ p1: A,
        _ p2: B,
        _ p3: C
    ) -> Parser<(A.Element, B.Element, C.Element)> {
        Zip3(p1: p1, p2: p2, p3: p3).asParser()
    }
    
    public static func zip<A: ParserType, B: ParserType, C: ParserType, D: ParserType>(
        _ p1: A,
        _ p2: B,
        _ p3: C,
        _ p4: D,
        debugPrefix: String? = nil
    ) -> Parser<(A.Element, B.Element, C.Element, D.Element)> {
        Zip4(p1: p1, p2: p2, p3: p3, p4: p4).asParser()
    }

    public static func zip<A: ParserType, B: ParserType, C: ParserType, D: ParserType, E: ParserType>(
        _ p1: A,
        _ p2: B,
        _ p3: C,
        _ p4: D,
        _ p5: E,
        debugPrefix: String? = nil
    ) -> Parser<(A.Element, B.Element, C.Element, D.Element, E.Element)> {
        Zip5(p1: p1, p2: p2, p3: p3, p4: p4, p5: p5).asParser()
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
        Zip6(p1: p1, p2: p2, p3: p3, p4: p4, p5: p5, p6: p6).asParser()
    }
}

// swiftlint:disable private_over_fileprivate
fileprivate struct Zip2<P1: ParserType, P2: ParserType>: ParserType, ParserConvertible {
    let name: String = "zip2"
    let p1: P1
    let p2: P2

    func run(_ reader: inout Reader) -> (P1.Element, P2.Element)? {
        let origin = reader
        guard let r1 = p1.run(&reader) else {
            reader = origin
            return nil
        }

        guard let r2 = p2.run(&reader) else {
            reader = origin
            return nil
        }

        return (r1, r2)
    }
}

// swiftlint:disable private_over_fileprivate
fileprivate struct Zip3<P1: ParserType,
                        P2: ParserType,
                        P3: ParserType>: ParserType, ParserConvertible {
    let name: String = "zip3"
    let p1: P1
    let p2: P2
    let p3: P3

    func run(_ reader: inout Reader) -> (P1.Element,
                                         P2.Element,
                                         P3.Element)? {
        let origin = reader
        guard let r1 = p1.run(&reader) else {
            reader = origin
            return nil
        }

        guard let r2 = p2.run(&reader) else {
            reader = origin
            return nil
        }

        guard let r3 = p3.run(&reader) else {
            reader = origin
            return nil
        }

        return (r1, r2, r3)
    }
}

// swiftlint:disable private_over_fileprivate
fileprivate struct Zip4<
    P1: ParserType,
    P2: ParserType,
    P3: ParserType,
    P4: ParserType
>: ParserType, ParserConvertible {
    let name: String = "zip4"
    let p1: P1
    let p2: P2
    let p3: P3
    let p4: P4

    func run(_ reader: inout Reader) -> (
        P1.Element,
        P2.Element,
        P3.Element,
        P4.Element
    )? {
        let origin = reader
        guard let r1 = p1.run(&reader) else {
            reader = origin
            return nil
        }

        guard let r2 = p2.run(&reader) else {
            reader = origin
            return nil
        }

        guard let r3 = p3.run(&reader) else {
            reader = origin
            return nil
        }

        guard let r4 = p4.run(&reader) else {
            reader = origin
            return nil
        }

        return (r1, r2, r3, r4)
    }
}

// swiftlint:disable private_over_fileprivate
fileprivate struct Zip5<
    P1: ParserType,
    P2: ParserType,
    P3: ParserType,
    P4: ParserType,
    P5: ParserType
>: ParserType, ParserConvertible {
    let name: String = "zip5"
    let p1: P1
    let p2: P2
    let p3: P3
    let p4: P4
    let p5: P5

    func run(_ reader: inout Reader) -> (
        P1.Element,
        P2.Element,
        P3.Element,
        P4.Element,
        P5.Element
    )? {
        let origin = reader
        guard let r1 = p1.run(&reader) else {
            reader = origin
            return nil
        }

        guard let r2 = p2.run(&reader) else {
            reader = origin
            return nil
        }

        guard let r3 = p3.run(&reader) else {
            reader = origin
            return nil
        }

        guard let r4 = p4.run(&reader) else {
            reader = origin
            return nil
        }

        guard let r5 = p5.run(&reader) else {
            reader = origin
            return nil
        }

        return (r1, r2, r3, r4, r5)
    }
}

// swiftlint:disable private_over_fileprivate
fileprivate struct Zip6<
    P1: ParserType,
    P2: ParserType,
    P3: ParserType,
    P4: ParserType,
    P5: ParserType,
    P6: ParserType
>: ParserType, ParserConvertible {
    let name: String = "zip6"
    let p1: P1
    let p2: P2
    let p3: P3
    let p4: P4
    let p5: P5
    let p6: P6

    func run(_ reader: inout Reader) -> (
        P1.Element,
        P2.Element,
        P3.Element,
        P4.Element,
        P5.Element,
        P6.Element
    )? {
        let origin = reader
        guard let r1 = p1.run(&reader) else {
            reader = origin
            return nil
        }

        guard let r2 = p2.run(&reader) else {
            reader = origin
            return nil
        }

        guard let r3 = p3.run(&reader) else {
            reader = origin
            return nil
        }

        guard let r4 = p4.run(&reader) else {
            reader = origin
            return nil
        }

        guard let r5 = p5.run(&reader) else {
            reader = origin
            return nil
        }

        guard let r6 = p6.run(&reader) else {
            reader = origin
            return nil
        }

        return (r1, r2, r3, r4, r5, r6)
    }
}
