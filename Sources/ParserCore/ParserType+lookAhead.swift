//
//  Parser+lookAhead.swift
//  Dumpling
//
//  Created by Wojciech Chojnacki on 30/11/2019.
//  Copyright © 2019 Wojciech Chojnacki. All rights reserved.
//

import Foundation

extension ParserType {
    /**
     Execute parser without consuming reader's content
     */
    @inlinable
    @inline(__always)
    public func lookAhead() -> Parser<Self.Element> {
        let parserIdentifier: String = "LookAheadIdentifier"
        // prevent multiple nested lookAhead parsers
        if let parser = self as? Parser<Self.Element> {
            if parser.nestedParserIdentifier == parserIdentifier {
                return parser
            }
        }

        return .init("lookAhead:\(name)", parserIdentifier) { reader in
            let origin = reader
            let result = self.run(&reader)
            reader = origin
            return result
        }
    }
}
