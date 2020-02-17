//
//  Location.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 15.2.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

struct Location: Equatable, Hashable {
    
    static let zero = Location(x: 0, y: 0)
    
    var x: Int
    var y: Int
    
    mutating func shift(toward direction: Direction, by steps: Int = 1) {
        switch direction {
        case .up:
            self.y += steps
        case .right:
            self.x += steps
        case .down:
            self.y -= steps
        case .left:
            self.x -= steps
        default:
            break
        }
    }
    
    func shifted(toward direction: Direction, by steps: Int = 1) -> Location {
        switch direction {
        case .up:
            return Location(x: self.x, y: self.y + steps)
        case .right:
            return Location(x: self.x + steps, y: self.y)
        case .down:
            return Location(x: self.x, y: self.y - steps)
        case .left:
            return Location(x: self.x - steps, y: self.y)
        case .undefined:
            return self
        }
    }
}
