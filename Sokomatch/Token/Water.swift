//
//  Blob.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 18.2.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import Foundation

struct Water: Token {
    
    let id: UUID
    let type: TokenType = .water
    var location: Location
    var value: Int = 1
    var style = TokenStyle(
        color: .blue,
        image: "water")
    
    var constructors: [TokenType] = []
    var destructors: [TokenType] = [.fire]
    
    init(id: UUID, location: Location) {
        self.id = id
        self.location = location
    }
    
    init(location: Location) {
        self.init(id: UUID(), location: location)
    }
    
    func canCombine(with other: Token) -> Bool {
        [self.type, TokenType.fire].contains(other.type)
    }
}
