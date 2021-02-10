//
//  Token.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 16.2.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import SwiftUI
import Emerald

enum TokenType: String {
    
    case avatar
    case collectible
    case trigger
    case tile
    case mechanism
}

protocol Token {
    
    var id: UUID { get }
    var type: TokenType { get }
}

protocol Movable: Token {
    
    var location: Location { get set }
}

protocol Interactable: Token {
    
    func canInteract(with other: Interactable) -> Bool
    func interact(with other: Interactable) -> Self?
}

protocol Piece: Token, Hashable, Identifiable {
    
}

extension Piece {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}
