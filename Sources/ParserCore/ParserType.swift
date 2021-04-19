//
//  ParserType.swift
//  Dumpling
//
//  Created by Wojciech Chojnacki on 30/11/2019.
//  Copyright © 2019 Wojciech Chojnacki. All rights reserved.
//

import Foundation

public protocol ParserType {
    associatedtype Element
    var name: String { get }
    func run(_ reader: inout Reader) -> Element?
}

extension ParserType {
    @inlinable
    @inline(__always)
    public static func zero() -> Parser<Element> {
        .init("zero") { _ in nil }
    }

    @inlinable
    @inline(__always)
    public static func just(_ value: Element) -> Parser<Element> {
        .init("just(\(value))") { _ in
            value
        }
    }

    @inlinable
    @inline(__always)
    public func map<R>(_ transform: @escaping (Element) -> R) -> Parser<R> {
        .init(self.name) { reader in
            guard let res = self.run(&reader) else { return nil }
            return transform(res)
        }
    }

    @inlinable
    @inline(__always)
    public func mapTo<T>(_ value: T) -> Parser<T> {
        self.map { _ in value }
    }

    @inlinable
    @inline(__always)
    public var mapToVoid: Parser<Void> {
        let parserIdentifier: String = "MapToVoidIdentifier"
        if let parser = self as? Parser<Void> {
            if parser.nestedParserIdentifier == parserIdentifier {
                return parser
            }
        }

        return .init(self.name, parserIdentifier) { reader in
            if self.run(&reader) != nil {
                return ()
            }

            return nil
        }
    }

    @inlinable
    @inline(__always)
    public func flatMap<R>(_ transform: @escaping (Element) -> Parser<R>) -> Parser<R> {
        .init(self.name) { reader in
            let origin = reader
            if let res = self.run(&reader) {
                let op2 = transform(res)
                let res2 = op2.run(&reader)

                if res2 == nil {
                    reader = origin
                }
                return res2
            }

            return nil
        }
    }

    /// Print parser result and reader content before and after execution
    public func debug(_ prefix: String) -> Parser<Element> {
        .init(self.name) { reader in
            print("\(prefix):->:\(reader)")
            let result = self.run(&reader)
            print("\(prefix):<-:\(String(describing: result))")
            print("\(prefix):--:\(reader)")
            return result
        }
    }

}
