//: [Previous](@previous)

import UIKit
import Dumpling

// ## Change theme

let theme = AttributedStringTheme(
   baseFont: .systemFont(ofSize: 13),
   color: .blue
)

theme.addStyle(
    forKey: .strong,
    style: StringStyle.foregroundColor(Color.red)
)

theme.addStyle(
    forKey: .em,
    style: compose(
        StringStyle.foregroundColor(Color.green),
        StringStyle.traits([.italic])
    )
)

let string = Markdown()
        .parse(text)
        .renderAttributedString(theme: theme)


//: [Next](@next)
