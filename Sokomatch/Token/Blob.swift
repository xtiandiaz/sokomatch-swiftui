//
//  Blob.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 18.2.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import SwiftUI

struct Blob: Token, Combinable, Movable {

    static let example = Blob(
        location: Location.zero,
        style: TokenStyle(color: Color.blue))
    static let example2 = Blob(
        location: Location(x: 1, y: 1),
        style: TokenStyle(color: Color.red))
    
    let id: UUID
    var location: Location
    var style: TokenStyle
    var value: Int = 1
    
    init(id: UUID, location: Location, style: TokenStyle) {
        self.id = id
        self.location = location
        self.style = style
    }
    
    init(location: Location, style: TokenStyle) {
        self.init(id: UUID(), location: location, style: style)
    }
    
    func combine(with other: Combinable) -> Token? {
        if other.style.color != self.style.color {
            return nil
        }
        
        var result = self
        result.value += other.value
        return result
    }
}
