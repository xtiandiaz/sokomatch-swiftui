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
    
//    subscript(location: Location) -> Locatable? {
//        get { locatables[location] }
//        set {
//            guard let introducing = newValue else {
//                print("Attempted to set nil as Locatable at \(location)")
//                return
//            }
//            if
//                !isAvailable(location: location),
//                let existing = locatables[location],
//                existing.id != introducing.id {
//                    print("A Locatable with id \(existing.id) already exists at \(location)")
//                return
//            }
//
//            locatables[introducing.location] = nil
//            locatables[location] = newValue
//        }
//    }
    
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
            let token = _tokens[tokenId] else { return }

        let destination = board.nextLocation(from: location, toward: direction) {
            [weak self] in
            self?._targets[$0] == nil
        }
        if destination == location {
            return
        }
        
        _targets[location] = nil
        _targets[destination] = token.id
        _tokens[token.id] = Token(id: token.id, location: destination, style: token.style)
    }
    
    func token(fromId id: UUID) -> Token {
        _tokens[id]!
    }
}
