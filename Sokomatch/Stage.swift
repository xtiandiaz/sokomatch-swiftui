//
//  Stage.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 16.2.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import SwiftUI

class Stage: ObservableObject {
    
    @Published private(set) var _ids = [UUID]()
    @Published private(set) var _targets = [Location: UUID]()
    @Published private(set) var _tokens = [UUID: Token]()
    
    private let map: Map
    
    init(map: Map) {
        self.map = map
    }
    
    func place(token: Token) {
        _ids.append(token.id)
        _tokens[token.id] = token
        _targets[token.location] = token.id
    }
    
    func move(tokenAtLocation location: Location, toward direction: Direction) {
        if !map.isValid(location: location) {
            return
        }

        guard
            let tokenId = _targets[location],
            let token = _tokens[tokenId] else { return }

        let destination = map.nextLocation(from: location, toward: direction)
        if destination == location {
            return
        }
        
        _targets[location] = nil
        _targets[destination] = token.id
        _tokens[token.id] = Token(id: token.id, location: destination, style: .blue)
    }
    
    func token(fromId id: UUID) -> Token {
        _tokens[id]!
    }
}
