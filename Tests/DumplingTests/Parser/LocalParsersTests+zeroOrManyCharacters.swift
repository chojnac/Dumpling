//
//  LocalParsersTests+zeroOrManyCharacters.swift
//  DumplingTests
//
//  Created by Wojciech Chojnacki on 27/03/2021.
//  Copyright © 2021 Dumpling. All rights reserved.
//

import Foundation
import XCTest
import Dumpling

final class LocalParsersTests_zeroOrManyCharacters: XCTestCase {
    func test_string_match() {
        var input = Substring("1 ala ma \nkota")
        
        let codeParamsCharacterSet = CharacterSet.alphanumerics.union(CharacterSet.whitespaces)
        
        let result = Parsers.zeroOrManyCharacters(inSet: codeParamsCharacterSet).run(&input)
        
        XCTAssertEqual(result, "1 ala ma ")
        XCTAssertEqual(String(input), "\nkota")
    }
    
    func test_nothing_match() {
        var input = Substring("\nkota")
        
        let codeParamsCharacterSet = CharacterSet.alphanumerics.union(CharacterSet.whitespaces)
        
        let result = Parsers.zeroOrManyCharacters(inSet: codeParamsCharacterSet).run(&input)
        
        XCTAssertEqual(result, "")
        XCTAssertEqual(String(input), "\nkota")
    }
    
    func test_empty_match() {
        var input = Substring("kota")
        
        let codeParamsCharacterSet = CharacterSet.alphanumerics.union(CharacterSet.whitespaces)
        
        let result = Parsers.zeroOrManyCharacters(inSet: codeParamsCharacterSet).run(&input)
        
        XCTAssertEqual(result, "kota")
        XCTAssertEqual(String(input), "")
    }
}
