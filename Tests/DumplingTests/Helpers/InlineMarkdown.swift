//
//  InlineMarkdown.swift
//  DumplingTests
//
//  Created by Wojciech Chojnacki on 27/03/2021.
//  Copyright © 2021 Dumpling. All rights reserved.
//

import Foundation
@testable import Dumpling

final class InlineMarkdown: MarkdownType {
    let parser: Markdown
    public init(_ config: Markdown.FragmentsConfig = .default) {
        parser = Markdown(config)
    }

    func inline(exitParser: Parser<Void>, preExitCheckParser: Parser<Void>?) -> Parser<[ASTNode]> {
        parser.inline(
            exitParser: exitParser,
            preExitCheckParser: preExitCheckParser
        )
    }
}
