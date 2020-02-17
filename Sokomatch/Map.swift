//
//  Map.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 15.2.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import CoreGraphics
import SwiftUI

protocol Locatable {
    var id: UUID { get }
    var location: Location { get }
}

class Map: ObservableObject {
    
    let cols: Int
    let rows: Int
    let tileSize: CGFloat
    let center: Location
    
    private var locatables = Dictionary<Location, Locatable>()
    
    init(cols: Int, rows: Int, tileSize: CGFloat) {
        self.cols = cols
        self.rows = rows
        self.tileSize = tileSize
        center = Location(x: cols / 2, y: rows / 2)
    }
    
    subscript(location: Location) -> Locatable? {
        get { locatables[location] }
        set {
            guard let introducing = newValue else {
                print("Attempted to set nil as Locatable at \(location)")
                return
            }
            if
                !isAvailable(location: location),
                let existing = locatables[location],
                existing.id != introducing.id {
                    print("A Locatable with id \(existing.id) already exists at \(location)")
                return
            }
            
            locatables[introducing.location] = nil
            locatables[location] = newValue
        }
    }
    
    func isValid(location: Location) -> Bool {
        location.x >= 0 && location.x < cols && location.y >= 0 && location.y < rows
    }
    
    func isAvailable(location: Location) -> Bool {
        locatables[location] == nil
    }
    
    func nextLocation(from origin: Location, toward direction: Direction) -> Location {
        let next = origin.shifted(toward: direction)
        if !isValid(location: next) || !isAvailable(location: next) {
            return origin
        }
        return nextLocation(from: next, toward: direction)
    }
}
