//
//  Reader.swift
//  Dumpling
//
//  Created by Wojciech Chojnacki on 19/04/2021.
//  Copyright © 2021 Dumpling. All rights reserved.
//

import Foundation

public struct Reader {
    public typealias Index = String.Index
    public let base: String
    public let startIndex: Index
    public let endIndex: Index

    public init(_ base: String, startIndex: Index, endIndex: Index) {
        self.base = base
        self.startIndex = startIndex
        self.endIndex = endIndex
    }

    public init(_ base: String) {
        self.base = base
        self.startIndex = base.startIndex
        self.endIndex = base.endIndex
    }

    public var isEmpty: Bool {
        startIndex == endIndex
    }

    public var first: Character? {
        isEmpty ? nil : base[startIndex]
    }

    public func dropFirst() -> Reader {
        if startIndex == base.endIndex {
            return self
        }
        let newBegin = base.index(
            startIndex,
            offsetBy: 1,
            limitedBy: base.endIndex
        ) ?? base.endIndex

        return Reader(base, startIndex: newBegin, endIndex: endIndex)
    }

    public func dropFirst(_ n: Int = 1) -> Reader {
        let newBegin = base.index(
            startIndex,
            offsetBy: n,
            limitedBy: base.endIndex
        ) ?? base.endIndex

        return Reader(base, startIndex: newBegin, endIndex: endIndex)
    }

    public func sub(_ startIndex: Index, _ endIndex: Index) -> Reader {
        return Reader(base, startIndex: startIndex, endIndex: endIndex)
    }

    public func stepBack() -> Reader {
        let newBegin = base.index(
            startIndex,
            offsetBy: -1,
            limitedBy: base.startIndex
        ) ?? base.startIndex
        return Reader(base, startIndex: newBegin, endIndex: endIndex)
    }

    public func sub(endIndex: Index) -> Reader {
        return Reader(base, startIndex: startIndex, endIndex: endIndex)
    }

    public func string() -> String {
        String(base[startIndex..<endIndex])
    }

    public func starts(with string: String) -> Bool {
        base[startIndex..<endIndex].starts(with: string)
    }
}

extension Reader: CustomStringConvertible {
    public var description: String {
        String(base[startIndex..<endIndex])
    }
}
