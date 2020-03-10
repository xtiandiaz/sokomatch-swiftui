//
//  Boulder.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 10.3.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import Foundation

struct Boulder: Token, Movable {
    
    let id: UUID
    let type: TokenType = .boulder
    var location: Location
    var value: Int = 1
    var style = TokenStyle(fillColor: .gray)
    
    init(id: UUID, location: Location) {
        self.id = id
        self.location = location
    }
    
    init(location: Location) {
        self.init(id: UUID(), location: location)
    }
}
