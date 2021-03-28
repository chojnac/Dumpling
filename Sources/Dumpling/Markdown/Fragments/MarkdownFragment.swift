//
//  MarkdownFragment.swift
//  Dumpling
//
//  Created by Wojciech Chojnacki on 27/03/2021.
//  Copyright © 2021 Dumpling. All rights reserved.
//

import Foundation

public protocol MarkdownInlineFragment {
    associatedtype ASTNodeType
    var identifier: String { get }
    func build(markdown: MarkdownType) -> Parser<ASTNodeType>
}

public protocol MarkdownBlockFragment {
    associatedtype ASTNodeType
    var identifier: String { get }
    func build(markdown: MarkdownType) -> Parser<ASTNodeType>
}

public struct AnyMarkdownInlineFragment: MarkdownInlineFragment {
    private let _build: (MarkdownType) -> Parser<ASTNode>
    public let identifier: String
    init<F: MarkdownInlineFragment>(_ fragment: F) where F.ASTNodeType: ASTNode {
        self.identifier = fragment.identifier
        _build = {
            fragment.build(markdown: $0).map { $0 as ASTNode }
        }
    }

    public func build(markdown: MarkdownType) -> Parser<ASTNode> {
        _build(markdown)
    }
}

public struct AnyMarkdownBlockFragment: MarkdownBlockFragment {
    private let _build: (MarkdownType) -> Parser<ASTNode>
    public let identifier: String
    init<F: MarkdownBlockFragment>(_ fragment: F) where F.ASTNodeType: ASTNode {
        self.identifier = fragment.identifier
        _build = {
            fragment.build(markdown: $0).map { $0 as ASTNode }
        }
    }

    public func build(markdown: MarkdownType) -> Parser<ASTNode> {
        _build(markdown)
    }
}

extension MarkdownInlineFragment where ASTNodeType: ASTNode {
    public func any() -> AnyMarkdownInlineFragment {
        AnyMarkdownInlineFragment(self)
    }
}

extension MarkdownBlockFragment where ASTNodeType: ASTNode {
    public func any() -> AnyMarkdownBlockFragment {
        AnyMarkdownBlockFragment(self)
    }
}
