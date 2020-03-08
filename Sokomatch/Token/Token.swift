//
//  Token.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 16.2.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import SwiftUI

protocol Token {
    
    var id: UUID { get }
    var type: TokenType { get }
    var value: Int { get set }
    var location: Location { get set }
    var style: TokenStyle { get }
    var canMove: Bool { get }
    
    var constructors: [TokenType] { get }
    var destructors: [TokenType] { get }
    
    func canCombine(with other: Token) -> Bool
    func combine(with other: Token) -> Token?
    func add(_ value: Int) -> Token?
    func destruct(by other: Token) -> Token?
    func construct(with other: Token) -> Token?
}

extension Token {
    
    var canMove: Bool { true }
    
    func canCombine(with other: Token) -> Bool {
        self.type == other.type
            || destructors.contains(other.type)
            || constructors.contains(other.type)
    }
    
    func combine(with other: Token) -> Token? {
        if other.type == self.type {
            return add(other.value)
        } else if destructors.contains(other.type) {
            return destruct(by: other)
        } else if constructors.contains(other.type) {
            return construct(with: other)
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
    
    func destruct(by other: Token) -> Token? {
        add(-other.value)
    }
    
    func construct(with other: Token) -> Token? {
        return nil
    }
}
