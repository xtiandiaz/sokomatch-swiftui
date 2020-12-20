//
//  TokenType.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 8.3.2020.
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
    case actor
    
    var color: Color {
        switch self {
        case .fire: return Color.orange
        case .water: return Color.blue
        case .actor, .trigger: return Color.white
        default: return Color.clear
        }
    }
    
    func create(withLocation location: Location) -> Token {
        switch self {
        case .water:
            return Water(location: location)
        case .fire:
            return Fire(location: location)
        case .bomb:
            return Bomb(location: location)
        case .wall:
            return Wall(location: location)
        case .target:
            return Target(location: location)
        case .actor:
            return Actor(location: location)
        case .trigger:
            return Trigger(event: .goal, location: location)
        }
    }
}
