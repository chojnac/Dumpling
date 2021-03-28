//: [Previous](@previous)

import UIKit
import Dumpling

// Produce html
let html = Markdown().parse(text).renderHTML()

// Produce attributed string using build-in theme
let string = Markdown().parse(text).renderAttributedString()


//: [Next](@next)
