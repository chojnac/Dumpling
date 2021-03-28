//
//  Parser.swift
//  Dumpling
//
//  Created by Wojciech Chojnacki on 30/11/2019.
//  Copyright © 2019 Wojciech Chojnacki. All rights reserved.
//

import Foundation

public typealias Reader = Substring

public protocol ParserType {
    associatedtype Element
    var name: String { get }
    func run(_ reader: inout Reader) -> Element?
}

public struct Parser<T>: ParserType {
    public typealias Element = T
    public let name: String
    let action: (inout Reader) -> Element?

    public init(_ name: String, _ run: @escaping (inout Reader) -> Element?) {
        self.name = name
        self.action = run
    }

    public func run(_ reader: inout Reader) -> Element? {
        self.action(&reader)
    }

    public func rename(_ name: String) -> Parser<Element> {
        return .init(name) { self.run(&$0) }
    }
}

extension ParserType {
    public static func zero() -> Parser<Element> {
        .init("zero") { _ in nil }
    }

    public static func just(_ value: Element) -> Parser<Element> {
        .init("just(\(value))") { _ in
            value
        }
    }

    public func map<R>(_ transform: @escaping (Element) -> R) -> Parser<R> {
        .init(self.name) { reader in
            guard let res = self.run(&reader) else { return nil }
            return transform(res)
        }
    }

    public func mapTo<T>(_ value: T) -> Parser<T> {
        self.map { _ in value }
    }

    public var mapToVoid: Parser<Void> {
        self.map { _ in () }
    }

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

    /**
     Execute parser without consuming reader's content
     */
    public func lookAhead() -> Parser<Self.Element> {
        .init("lookAhead:\(name)") { reader in
            let origin = reader
            let result = self.run(&reader)
            reader = origin
            return result
        }
    }
}

public protocol OptionalType {
    associatedtype Wrapped

    var asOptional: Wrapped? { get }
}

extension Optional: OptionalType {
    public var asOptional: Wrapped? { return self }
}

extension Parser where Element: OptionalType {
    public func unwrap() -> Parser<Element.Wrapped> {
        return .init(self.name) { reader in
            let original = reader
            guard let result = self.run(&reader), let value = result.asOptional else {
                reader = original
                return nil
            }

            return value
        }
    }
}
extension Parser: CustomStringConvertible, CustomDebugStringConvertible {
    public var debugDescription: String { name }

    public var description: String { name }
}
