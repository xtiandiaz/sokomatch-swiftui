//
//  Board.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 16.2.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import SwiftUI

class Board {
    
    static let example = Board(cols: 6, rows: 6, tileSize: 50)
    
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
    
    func isValid(location: Location) -> Bool {
        location.x >= 0 && location.x < cols && location.y >= 0 && location.y < rows
    }
    
    func isAvailable(location: Location) -> Bool {
//        locatables[location] == nil
        return true
    }
    
    func nextLocation(from origin: Location, toward direction: Direction) -> Location {
        let next = origin.shifted(toward: direction)
        if !isValid(location: next) || !isAvailable(location: next) {
            return origin
        }
        return nextLocation(from: next, toward: direction)
    }
}
