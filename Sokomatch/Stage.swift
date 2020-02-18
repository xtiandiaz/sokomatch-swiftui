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
    
    private let board: Board
    
    init(board: Board) {
        self.board = board
    }
    
    func place(token: Token) {
        _ids.append(token.id)
        _tokens[token.id] = token
        _targets[token.location] = token.id
    }
    
    func move(tokenAtLocation location: Location, toward direction: Direction) {
        if !board.isValid(location: location) {
            return
        }

        guard
            let tokenId = _targets[location],
            var token = _tokens[tokenId]
        else { return }
        
        if !token.canMove {
            print("Token can't be moved")
            return
        }
        
        let destination = board.nextLocation(from: location, toward: direction) {
            [weak self] in
            self?._targets[$0] == nil
        }
        if destination == location {
            return
        }
        
        // Mutates the struct, thus creating a new, updated instance
        token.location = destination
        
        _targets[location] = nil
        _targets[destination] = token.id
        _tokens[token.id] = token
    }
    
    func token(fromId id: UUID) -> Token {
        _tokens[id]!
    }
}
