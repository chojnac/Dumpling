//
//  Helpers.swift
//  ParserCoreTests
//
//  Created by Wojciech Chojnacki on 28/05/2020.
//  Copyright © 2020 Wojciech Chojnacki. All rights reserved.
//

import Foundation
import Dumpling

public func pChar(character: Character) -> Parser<Character> {
    .init("pChar:'\(character)'") { reader in
        let origin = reader
        guard let ch = reader.first else { return nil }

        guard ch == character else {
            reader = origin
            return nil
        }

        reader = reader.dropFirst()
        return character
    }
}
