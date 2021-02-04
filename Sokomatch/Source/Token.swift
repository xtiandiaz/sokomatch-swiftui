//
//  Token.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 16.2.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import SwiftUI
import Emerald

enum TokenType: UInt32 {
    
    case target
    case water
    case fire
    case bomb
    case wall
    case trigger
    case avatar
    case collectible
    case doorway
    
    var color: Color {
        switch self {
        case .fire: return Color.orange
        case .water: return Color.blue
        case .avatar, .trigger: return Color.white
        case .collectible: return Color.yellow
        default: return Color.clear
        }
    }
}


protocol Token {
    
    var id: UUID { get }
    var type: TokenType { get }
    var value: Int { get set }
    var location: Location { get set }
    
    func add(_ value: Int) -> Token
}

extension Token {
    
    func add(_ value: Int) -> Token {
        var result = self
        result.value = self.value + value
        return result
    }
}

protocol Movable { }

protocol Interactable: Token {
    
    func interact(with other: Interactable) -> Token?
}

protocol Shovable { }
