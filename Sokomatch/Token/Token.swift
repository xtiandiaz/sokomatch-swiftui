//
//  Token.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 16.2.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import SwiftUI

struct Token: Identifiable {
    
    static let example = Token(
        location: Location.zero,
        style: TokenStyle(color: Color.blue))
    static let example2 = Token(
        location: Location(x: 1, y: 1),
        style: TokenStyle(color: Color.red))
    
    let id: UUID
    var location: Location
    var style: TokenStyle
    
    init(id: UUID, location: Location, style: TokenStyle) {
        self.id = id
        self.location = location
        self.style = style
    }
    
    init(location: Location, style: TokenStyle) {
        self.init(id: UUID(), location: location, style: style)
    }
    
    static func == (lhs: Token, rhs: Token) -> Bool {
        return lhs.id == rhs.id
    }
}

struct TokenStyle: Hashable {
    
    static let red = TokenStyle(color: .red)
    static let green = TokenStyle(color: .green)
    static let blue = TokenStyle(color: .blue)
    
    var color: Color
}
