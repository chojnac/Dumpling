# Dumpling

[![Build Status](https://github.com/chojnac/Dumpling/actions/workflows/ci-mac.yaml/badge.svg?branch=main)](https://github.com/chojnac/Dumpling/actions/workflows/ci-mac.yaml)
[![Version](https://img.shields.io/cocoapods/v/Dumpling.svg?style=flat)](https://cocoapods.org/pods/Dumpling)
[![License](https://img.shields.io/cocoapods/l/Dumpling.svg?style=flat)](https://cocoapods.org/pods/Dumpling)
[![Platform](https://img.shields.io/cocoapods/p/Dumpling.svg?style=flat)](https://cocoapods.org/pods/Dumpling)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

**Dumpling** is a pure Swift customisable and extensible Markdown parser for iOS, macOS and Linux.  

## Features

- 100% Swift
- Easy to extend with new markdown tags, output formats or customise existing implementations.
- Intermediate layer describing document structure with Abstract Syntax Tree
- Build-in support for rendering outputs as the Plain Text, HTML, NSAttributedString.
- Multiplatform - iOS, macOS, Linux.

## Internal architecture

Dumpling uses a highly extensible and modular functional approach called parser combinator.

Markdown parser produces an intermediate data model called Abstract Syntax Tree (AST).

Renderer implementations use AST to produce the final output. Dumpling provides 3 main build-in output formats - Plain Text, HTML and NSAttributedString.

## Supported Elements

````
*italic* or _italics_ 
**bold** or __bold__ 
~~strikethrough~~ 

# Header 1
## Header 2
### Header 3
#### Header 4
##### Header 5
###### Header 6

Horizontal lines (Thematic breaks)

***
---
___
* * *   *
-----------------


* List
  - List
+ List

1. Ordered 
1. Lists with **style**

Inline `code` or 
``` 
block code
```
[Links](http://github.com/chojnac/)

> Blockquotes
> > and  nested blockquote.
>
> ## With nested content 
> 1.   This is the **first** list ~~item~~.
> 2.   This is the *second* list item.
````

Please note that the goal of this project was to create a foundation for a  flexible Markdown parser. Dumpling doesn't fully support all Markdown specs. This is a very young implementation so it covers only the most common set of Markdown features. 

## Installation

### CocoaPods

```ruby
pod 'Dumpling'
```
### Carthage

```
github "chojnac/Dumpling.git" ~> 0.1.0
```

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/chojnac/Dumpling.git", .upToNextMajor(from: "0.1.0"))
]
```


## Usage

### Basic usage
Parse text and produce html:

```swift
import Dumpling 

let text = "**Lorem ipsum**"
let html = Markdown().parse(text).renderHTML()
```

or NSAttributedText:

```swift
import Dumpling 

let text = "**Lorem ipsum**"
let string = Markdown().parse(text).renderAttributedString()
```

### Change NSAttributedText style

```swift
import Dumpling 

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
```

You will find more advanced examples in the [project example playground](https://github.com/chojnac/Dumpling/tree/main/Examples/Playground.playground)

## License

Dumpling is available under the MIT license. See the [LICENSE](https://github.com/chojnac/Dumpling/blob/master/LICENSE) file for more info.

Markdown test document used in the project is based on [Max Stoiber's Markdown Test File](https://github.com/mxstbr/)markdown-test-file)
