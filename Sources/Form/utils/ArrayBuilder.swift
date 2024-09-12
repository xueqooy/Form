//
//  ArrayBuilder.swift
//
//  Created by xueqooy on 2024/9/10.
//

import Foundation

@resultBuilder
public struct ArrayBuilder<Element> {
    
    public static func buildPartialBlock(first: Element) -> [Element] { [first] }
    public static func buildPartialBlock(first: [Element]) -> [Element] { first }
    public static func buildPartialBlock(accumulated: [Element], next: Element) -> [Element] { accumulated + [next] }
    public static func buildPartialBlock(accumulated: [Element], next: [Element]) -> [Element] { accumulated + next }
    
    // Empty block
    public static func buildBlock() -> [Element] { [] }
    
    // Empty partial block. Useful for switch cases to represent no elements.
    public static func buildPartialBlock(first: Void) -> [Element] { [] }
    
    // Impossible partial block. Useful for fatalError().
    public static func buildPartialBlock(first: Never) -> [Element] {}
    
    // Block for an 'if' condition.
    public static func buildIf(_ element: [Element]?) -> [Element] { element ?? [] }
    
    // Block for an 'if' condition which also have an 'else' branch.
    public static func buildEither(first: [Element]) -> [Element] { first }
    
    // Block for the 'else' branch of an 'if' condition.
    public static func buildEither(second: [Element]) -> [Element] { second }
    
    // Block for an array of elements. Useful for 'for' loops.
    public static func buildArray(_ components: [[Element]]) -> [Element] { components.flatMap { $0 } }
}

public extension Array {
    
    init(@ArrayBuilder<Element> _ builder: () -> [Element]) {
        self.init(builder())
    }
}
