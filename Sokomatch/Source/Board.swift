//
//  Board.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 16.2.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import SwiftUI
import CoreGraphics
import Emerald

class Board: ObservableObject {
    
    let cols: Int
    let rows: Int
    let tileSize: CGFloat
    let center: Location
    
    init(cols: Int, rows: Int, tileSize: CGFloat) {
        self.cols = cols
        self.rows = rows
        self.tileSize = tileSize
        
        center = Location(x: cols / 2, y: rows / 2)
    }
    
    var tokenIds: [UUID] {
        Array(tokens.keys)
    }
    
    // MARK: Private
    
    private lazy var navigationController = NavigationController(map: self)
    
    @Published private var tokens = [UUID: Token]()
    @Published private var tokenLocations = [Location: Token]()
}

// MARK: - Token Management

extension Board {
    
    func place(token: Token) {
        guard isValid(location: token.location) else {
            return
        }
        
        tokens[token.id] = token
        tokenLocations[token.location] = token
    }
    
    func token(id: UUID) -> Token? {
        tokens[id]
    }
    
    // MARK: Private
    
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
    
    private func token(at location: Location) -> Token? {
        tokenLocations[location]
    }
}

// MARK: - Navigation

extension Board: Map {
    
    func move(tokenAtLocation origin: Location, toward direction: Direction) {
        guard
            isValid(location: origin),
            var token = token(at: origin),
            token is Movable
        else {
            return
        }
        
        let destination = navigationController.move(token: token, from: origin, toward: direction)
        guard destination != origin else {
            return
        }
        
        clear(location: origin)
        token.location = destination
        place(token: token)
    }
    
    func isValid(location: Location) -> Bool {
        location.x >= 0 && location.x < cols && location.y >= 0 && location.y < rows
    }
    
    func isAvailable(location: Location) -> Bool {
        token(at: location) == nil
    }
}

// MARK: - Layout

extension Board {
    
    var width: CGFloat {
        CGFloat(cols) * tileSize
    }
    
    var height: CGFloat {
        CGFloat(rows) * tileSize
    }
}

// MARK: - Templates

extension Board {
    
    static let preview = Board(cols: 6, rows: 6, tileSize: 50)
}
