//
//  Token.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 16.2.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import SwiftUI

protocol Movable {
    
    var canMove: Bool { get }
}

protocol Combinable {
    
    func canCombine(withOther other: Combinable) -> Bool
    mutating func combine(withOther other: Combinable)
}

protocol Token {
    
    var id: UUID { get }
    var location: Location { get set }
    var value: Int? { get set }
    var style: TokenStyle { get }
}

extension Token {
    
    var canMove: Bool { self is Movable }
    var isCombinable: Bool { self is Combinable }
}
