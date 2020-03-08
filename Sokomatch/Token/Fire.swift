//
//  Fire.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 8.3.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import Foundation

struct Fire: Token {
    
    let id: UUID
    let type: TokenType = .fire
    var location: Location
    var value: Int = 1
    var style = TokenStyle(
        color: .orange,
        image: "fire")
    
    var constructors: [TokenType] = []
    var destructors: [TokenType] = [.water]
    
    init(id: UUID, location: Location) {
        self.id = id
        self.location = location
    }
    
    init(location: Location) {
        self.init(id: UUID(), location: location)
    }
    
    func canCombine(with other: Token) -> Bool {
        [self.type, TokenType.water].contains(other.type)
    }
}
