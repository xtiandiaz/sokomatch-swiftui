//
//  TokenType.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 8.3.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

enum TokenType: UInt32 {
    
    case water
    case fire
    case bomb
    case boulder
    
    func create(withLocation location: Location) -> Token {
        switch self {
        case .water:
            return Water(location: location)
        case .fire:
            return Fire(location: location)
        case .bomb:
            return Bomb(location: location)
        case .boulder:
            return Boulder(location: location)
        }
    }
}
