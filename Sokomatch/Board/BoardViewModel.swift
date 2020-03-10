//
//  BoardViewModel.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 22.2.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import SwiftUI

class BoardViewModel: ObservableObject {
    
    static let transitionDuration: TimeInterval = 0.1
    
    let tileSize: CGFloat
    
    private let board: Board
    @Published private var tokens = [UUID: Token]()
    @Published private var tokenLocations = [Location: Token]()
    
    var tokenIds: [UUID] {
        Array(tokens.keys)
    }
    
    var width: CGFloat {
        CGFloat(board.cols) * board.tileSize
    }
    
    var height: CGFloat {
        CGFloat(board.rows) * board.tileSize
    }
    
    init(board: Board) {
        self.board = board
        tileSize = board.tileSize
    }
    
    func reset() {
        tokens = [UUID: Token]()
        tokenLocations = [Location: Token]()
    }
    
    func place(token: Token) {
        if !board.isValid(location: token.location) {
            return
        }
        
        tokens[token.id] = token
        tokenLocations[token.location] = token
    }
    
    func token(fromId id: UUID) -> Token? {
        tokens[id]
    }
    
    func move(tokenAtLocation location: Location, toward direction: Direction) {
        if !board.isValid(location: location) {
            return
        }
        
        guard var token = token(atLocation: location) else { return }
        
        if !token.isMovable {
            print("Token can't be moved")
            return
        }
        
        let destination = move(from: location, toward: direction, forToken: token)
        if destination == location {
            return
        }
        
        clear(location: location)
        
        // Mutates the struct, thus creating a new, updated instance:
        token.location = destination
        func isAvailable(location: Location) -> Bool {
            tokenLocations[location] == nil
        }

        place(token: token)
    }
    
    private func move(
        from origin: Location,
        toward direction: Direction,
        forToken token: Token) -> Location {
        let next = origin.shifted(toward: direction)
        
        if !board.isValid(location: next) {
            return origin
        }
        
        if !isAvailable(location: next) {
            guard
                let other = self.token(atLocation: next),
                token.canInteract(with: other)
            else {
                return origin
            }
            
            let result = token.interact(with: other)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + Self.transitionDuration) { [weak self] in
                guard var result = result else {
                    self?.removeAndClear(token: token)
                    self?.removeAndClear(token: other)
                    return
                }
                
                self?.remove(token: token)
                self?.remove(token: other)
                
                result.location = next
                
                self?.place(token: result)
            }
            return next
        }
        
        return move(from: next, toward: direction, forToken: token)
    }
    
    private func isAvailable(location: Location) -> Bool {
        token(atLocation: location) == nil
    }
    
    private func token(atLocation location: Location) -> Token? {
        tokenLocations[location]
    }
    
    private func removeAndClear(token: Token) {
        remove(token: token)
        clear(location: token.location)
    }
    
    private func remove(token: Token) {
        tokens[token.id] = nil
    }
    
    private func clear(location: Location) {
        tokenLocations[location] = nil
    }
}
