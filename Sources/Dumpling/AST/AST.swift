//
//  AST.swift
//  Dumpling
//
//  Created by Wojciech Chojnacki on 30/11/2019.
//  Copyright © 2019 Wojciech Chojnacki. All rights reserved.
//

import Foundation

public protocol ASTNode {
    var children: [ASTNode] { get }
}

extension ASTNode {
    static var typeName: String { "\(type(of: self))" }

    var typeName: String {
        Self.typeName
    }
}

public struct AST {
    public struct TextNode: ASTNode {
        public let children: [ASTNode] = []
        public let text: String

        public init(_ text: String) {
            self.text = text
        }

        public init(_ character: Character) {
            text = String(character)
        }

        public init(_ text: Substring) {
            self.text = String(text)
        }
    }

    public struct StyleNode: ASTNode {
        public let children: [ASTNode]
        public let id: StyleID

        public init(id: StyleID, children: [ASTNode]) {
            self.children = children
            self.id = id
        }
    }

    public struct ParagraphNode: ASTNode {
        public let children: [ASTNode]

        public init(children: [ASTNode]) {
            self.children = children
        }
    }

    public struct HeaderNode: ASTNode {
        public let children: [ASTNode]
        public let size: Int
        
        public init(size: Int, children: [ASTNode]) {
            self.size = size
            self.children = children
        }
    }

    public struct NewLineNode: ASTNode {
        public let children = [ASTNode]()
        public let soft: Bool
        
        public init(soft: Bool) {
            self.soft = soft
        }
    }

    public struct EOFNode: ASTNode {
        public var children = [ASTNode]()
        public init() {}
    }

    public struct SpaceNode: ASTNode {
        public var children = [ASTNode]()
        public let count: Int
        public init(count: Int) {
            self.count = count
        }
    }

    public struct LinkNode: ASTNode {
        public enum LinkValue: Equatable {
            case inline(String)
            case reference(String)
        }

        public let children: [ASTNode]
        public let link: LinkValue
        public let title: String?

        public init(text: String, link: LinkValue, title: String?) {
            children = [AST.TextNode(text)]
            self.link = link
            self.title = title
        }
    }

    public struct CodeNode: ASTNode {
        public let children: [ASTNode]
        public let params: String?
        public let isBlock: Bool
        
        public init(params: String?, body: String, isBlock: Bool) {
            children = [AST.TextNode(body)]
            self.params = params
            self.isBlock = isBlock
        }
    }

    public struct ListNode: ASTNode {
        public enum Kind {
            public enum Delimeter: Equatable {
                case period
                case paren
            }
            case bullet
            case ordered(start: Int, delimeter: Delimeter)
        }
        public let children: [ASTNode]
        public let kind: Kind
        public let level: Int

        public init(kind: Kind, level: Int, children: [ListElementNode]) {
            self.children = children
            self.kind = kind
            self.level = level
        }
    }

    public struct ListElementNode: ASTNode {
        public let children: [ASTNode]

        public init(children: [ASTNode]) {
            self.children = children
        }
    }

    public struct HorizontalLineNode: ASTNode {
        public let children: [ASTNode] = []

        public init() {}
    }

    public struct RootNode: ASTNode {
        public let children: [ASTNode]
        public init(children: [ASTNode]) {
            self.children = children
        }
    }
}
