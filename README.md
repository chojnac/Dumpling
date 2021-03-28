# Dumpling

[![Build Status](https://github.com/chojnac/DumplingMk3/actions/workflows/ci.yaml/badge.svg)](https://github.com/chojnac/DumplingMk3/actions)
[![Version](https://img.shields.io/cocoapods/v/Dumpling.svg?style=flat)](https://cocoapods.org/pods/Dumpling)
[![License](https://img.shields.io/cocoapods/l/Dumpling.svg?style=flat)](https://cocoapods.org/pods/Dumpling)
[![Platform](https://img.shields.io/cocoapods/p/Dumpling.svg?style=flat)](https://cocoapods.org/pods/Dumpling)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

**Dumpling** is a pure Swift customisable and extensible Markdown parser for iOS and macOS.  

## Features

- 100% Swift
- Easy to extend with new markdown tags, output formats or customise existing implementations.
- Intermediate layer describing document structure with Abstract Syntax Tree
- Build-in support for rendering outputs as the Plain Text, HTML, NSAttributedString.

## Internal architecture

Dumpling uses highly extensible and modular functional approach called parser combinator.

Markdown parser produces an intermediate data model called Abstract Syntax Tree (AST).

Renderer implementations uses AST to produce the final output. Dumpling provides 3 main build-in output formats - Plain Text, HTML and NSAttributedString.

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

* List
  - List
+ List

1. Ordered 
1. Lists

Inline `code` or 
``` 
block code
```
[Links](http://github.com/chojnac/)
````

Please not that the goal of this project was to create a foundation for very flexible Markdown parser. Dumpling doesn't fully support all Markdown specs. This is very young implementation so it covers only most common set of Markdown features. 

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

You will find more advence examples in the [project example playground](https://github.com/chojnac/Dumpling/tree/main/Examples/Playground.playground)

## License

Dumpling is available under the MIT license. See the [LICENSE](https://github.com/chojnac/Dumpling/blob/master/LICENSE) file for more info.