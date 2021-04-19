//
//  ParserConvertible.swift
//  Dumpling
//
//  Created by Wojciech Chojnacki on 19/04/2021.
//  Copyright © 2021 Dumpling. All rights reserved.
//

import Foundation

public protocol ParserConvertible {
    associatedtype Element

    func asParser() -> Parser<Element>
}

extension ParserType where Self: ParserConvertible {
    @inlinable
    @inline(__always)
    public func asParser() -> Parser<Element> {
        if let parser = self as? Parser<Element> {
            return parser
        }
        return Parser<Element>(self.name, nil, self.run)
    }
}
