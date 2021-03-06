//
//  Token.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 16.2.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import SwiftUI

struct TokenCategory: OptionSet, Codable {
    
    static let map = TokenCategory(rawValue: 1 << 0)
    static let avatar = TokenCategory(rawValue: 1 << 1)
    static let collectible = TokenCategory(rawValue: 1 << 2)
    static let droppable = TokenCategory(rawValue: 1 << 3)
    static let trigger = TokenCategory(rawValue: 1 << 4)
    static let trap = TokenCategory(rawValue: 1 << 6)
    static let boundary = TokenCategory(rawValue: 1 << 7)
    static let movable = TokenCategory(rawValue: 1 << 8)
    
    let rawValue: Int
}

protocol Token: Configurable {
    
    var id: UUID { get }
    var category: TokenCategory { get }
    var location: Location { get }
    
    var collisionMask: [TokenCategory] { get }
    var interactionMask: [TokenCategory] { get }
    
    func affect(with other: Token) -> Self?
}

protocol Layerable: Token, Hashable, Identifiable, Codable {
}

extension Layerable {
    
    var id: UUID { id }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}
