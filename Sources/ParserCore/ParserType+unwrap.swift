//
//  ParserType+unwrap.swift
//  Dumpling
//
//  Created by Wojciech Chojnacki on 30/11/2019.
//  Copyright © 2019 Wojciech Chojnacki. All rights reserved.
//

import Foundation

public protocol OptionalType {
    associatedtype Wrapped

    var asOptional: Wrapped? { get }
}

extension Optional: OptionalType {
    public var asOptional: Wrapped? { return self }
}

extension ParserType where Element: OptionalType {
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
