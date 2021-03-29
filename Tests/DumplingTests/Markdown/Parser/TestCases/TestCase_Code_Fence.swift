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
        static let case01 = TestCase(
            text: "```test\n  func() {    \n  }   \n  ```",
            parsed: "<code params=\"test\" block=\"true\">  func() {    \n  }   </code>"
        )

        static let case02 = TestCase(
            text: "```  \n  func() {}   \n\n\n```",
            parsed: "<code block=\"true\">  func() {}   \n\n</code>"
        )

        static let case03 = TestCase(
            text: "Inline `code` or\n```\nblock code\n```",
            parsed: "<p>Inline␣<code>code</code>␣or⏎</p><code block=\"true\">block code</code>"
        )
    }
}
