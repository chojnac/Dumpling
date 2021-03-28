//: [Previous](@previous)

import Foundation
import UIKit
import Dumpling

let tag = EnclosedInlineFragment(id: "alert", str: "!!")
let config = zip(
    Markdown.FragmentsConfig.default,
    Markdown.FragmentsConfig(inline: [tag.any()], block: [])
)
let markdown = Markdown(config)

extension AttributedStringTheme.StyleKey {
    static let alert: Self = .init("alert")
}

let theme = AttributedStringTheme.default

theme.addStyle(
    forKey: .alert,
    style: compose(
        StringStyle.foregroundColor(.white),
        StringStyle.backgroundColor(.red)
    )
)

public let text = """
!!Danger, Will Robinson\\!!!
"""

let string = markdown.parse(text).renderAttributedString(theme: theme)

//: [Next](@next)
