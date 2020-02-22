//
//  Board.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 16.2.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import SwiftUI

class Board: ObservableObject {
    
    static let example = Board(cols: 6, rows: 6, tileSize: 50)
    
    let cols: Int
    let rows: Int
    let tileSize: CGFloat
    let center: Location
    
    @Published private(set) var tokens = [UUID: Token]()
    @Published private(set) var tokenLocations = [Location: Token]()
    
    init(cols: Int, rows: Int, tileSize: CGFloat) {
        self.cols = cols
        self.rows = rows
        self.tileSize = tileSize
        center = Location(x: cols / 2, y: rows / 2)
    }
    
    func place(token: Token) {
        tokens[token.id] = token
        tokenLocations[token.location] = token
    }
    
    func move(tokenAtLocation location: Location, toward direction: Direction) {
        guard var token = tokenLocations[location] else { return }
        
        let destination = nextLocation(from: location, toward: direction)
        if destination == location {
            return
        }
        
        // Mutates the struct, thus creating a new, updated instance
        token.location = destination
        
        tokenLocations[location] = nil
        tokenLocations[destination] = token
        tokens[token.id] = token
    }
    
    func isValid(location: Location) -> Bool {
        location.x >= 0 && location.x < cols && location.y >= 0 && location.y < rows
    }
    
    func isAvailable(location: Location) -> Bool {
        tokenLocations[location] == nil
    }
    
    private func nextLocation(from origin: Location, toward direction: Direction) -> Location {
        let next = origin.shifted(toward: direction)
        if !isValid(location: next) || !isAvailable(location: next) {
            return origin
        }
        return nextLocation(from: next, toward: direction)
    }
}
