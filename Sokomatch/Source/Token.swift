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
    case trigger
    case doorway
}

protocol Token {
    
    var id: UUID { get }
    var token: TokenType { get }
}

protocol Movable: Token {
    
    var location: Location { get set }
}

protocol Interactable: Token {
    
    func canInteract(with other: Interactable) -> Bool
    func interact(with other: Interactable) -> Self?
}

protocol Piece: Token, Codable, Hashable, Identifiable {

}

extension Piece {
    
    var id: UUID { id }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}
