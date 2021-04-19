//
//  Parser.swift
//  Dumpling
//
//  Created by Wojciech Chojnacki on 30/11/2019.
//  Copyright © 2019 Wojciech Chojnacki. All rights reserved.
//

import Foundation

public struct Parser<T>: ParserType {
    public typealias Element = T
    @usableFromInline
    // swiftlint:disable:next identifier_name
    internal var _name: String
    @usableFromInline
    // swiftlint:disable:next identifier_name
    internal let _run: (inout Reader) -> Element?
    public var name: String { _name }
    // helps with detecting duplicated nested parsers, check `Parser.lookAhead`
    public let nestedParserIdentifier: String?
    
    @inlinable
    public init(_ name: String, _ nestedParserIdentifier: String? = nil, _ run: @escaping (inout Reader) -> Element?) {
        self._name = name
        self._run = run
        self.nestedParserIdentifier = nestedParserIdentifier
    }

    @inlinable
    @inline(__always)
    public func run(_ reader: inout Reader) -> Element? {
        self._run(&reader)
    }

    @inlinable
    @inline(__always)
    public func rename(_ name: String) -> Parser<Element> {
        var p = self
        p._name = name
        return p
    }
}

extension Parser: CustomStringConvertible, CustomDebugStringConvertible {
    public var debugDescription: String { name }
    public var description: String { name }
}
