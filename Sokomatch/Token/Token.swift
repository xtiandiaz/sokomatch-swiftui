//
//  Token.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 16.2.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import SwiftUI

protocol Movable {
}

protocol Combinable {
    
    func canCombine(with other: Token) -> Bool
    func combine(with other: Token) -> Token?
}

extension Combinable where Self: Token {
    
    func canCombine(with other: Token) -> Bool {
        return self.type == other.type
    }
    
    func combine(with other: Token) -> Token? {
        return self.add(other.value)
    }
}

protocol Reactive {
    
    var catalysts: [TokenType] { get }
    
    func canReact(with other: Token) -> Bool
    func react(with other: Token) -> Token?
}

extension Reactive where Self: Token {
    
    func canReact(with other: Token) -> Bool {
        catalysts.contains(other.type)
    }
    
    func react(with other: Token) -> Token? {
        return value < other.value
            ? other.add(-value)
            : add(-other.value)
    }
}

protocol Token {
    
    var id: UUID { get }
    var type: TokenType { get }
    var value: Int { get set }
    var location: Location { get set }
    var style: TokenStyle { get }
    
    var isMovable: Bool { get }
    
    func canInteract(with other: Token) -> Bool
    func interact(with other: Token) -> Token?
    func add(_ value: Int) -> Token?
}

extension Token {
    
    var isMovable: Bool { self is Movable }
    
    func canInteract(with other: Token) -> Bool {
        canCombine(with: other) || canReact(with: other)
    }
    
    func interact(with other: Token) -> Token? {
        if canCombine(with: other), let self = self as? Combinable {
            return self.combine(with: other)
        }
        
        if canReact(with: other), let self = self as? Reactive {
            return self.react(with: other)
        }
        
        return nil
    }
    
    func add(_ value: Int) -> Token? {
        let sum = self.value + value
        if sum <= 0 {
            return nil
        }
        var result = self
        result.value = sum
        return result
    }
    
    private func canCombine(with other: Token) -> Bool {
        guard let self = self as? Combinable else { return false }
        return self.canCombine(with: other)
    }
    
    private func canReact(with other: Token) -> Bool {
        guard let self = self as? Reactive else { return false }
        return self.canReact(with: other)
    }
}
