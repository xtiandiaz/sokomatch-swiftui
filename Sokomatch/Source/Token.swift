//
//  Token.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 16.2.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import SwiftUI
import Emerald

enum TokenType: String, Codable {
    
    case map
    case avatar
    case collectible
    case shovable
    case trigger
    case access
    case droppable
}

protocol Token {
    
    var id: UUID { get }
    var token: TokenType { get }
    var location: Location { get set }
    
    func canInteract(with other: Token) -> Bool
    func interact(with other: Token) -> Self?
}

protocol Layerable: Token, Hashable, Identifiable {
    
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
