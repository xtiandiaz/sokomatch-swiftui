//
//  Bomb.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 10.3.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import Emerald

struct Bomb: Token, Reactive, Movable {
    
    let id: UUID
    let type: TokenType = .bomb
    var location: Location
    var value: Int = 1
    var style = TokenStyle(fillColor: .black, borderColor: .gray)
    
    var catalysts: [TokenType] = [.fire]
    
    init(id: UUID, location: Location) {
        self.id = id
        self.location = location
    }
    
    init(location: Location) {
        self.init(id: UUID(), location: location)
    }
}
