//
//  TestCase_Code_Fence.swift
//  DumplingTests
//
//  Created by Wojciech Chojnacki on 10/03/2021.
//  Copyright © 2021 Wojciech Chojnacki. All rights reserved.
//

@testable import Dumpling
import Foundation

extension TestCase {
    struct CodeFence {
        static let case01 = TestCase(text: "```test\n  func() {    \n  }   \n  ```",
                                     parsed: "<p><code params=\"test\">  func() {    \n  }   </code></p>")

        static let case02 = TestCase(text: "```  \n  func() {}   \n\n\n```",
                                     parsed: "<p><code>  func() {}   \n\n</code></p>")

    }
}
