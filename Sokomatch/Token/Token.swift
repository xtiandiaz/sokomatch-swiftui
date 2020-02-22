//
//  Token.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 16.2.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import SwiftUI

protocol Token: Stylable {
    
    var id: UUID { get }
    var location: Location { get set }
}

protocol Movable {
    
    var canMove: Bool { get }
}

protocol Accumulable {
    
     var value: Int { get set }
}

protocol Stylable {
    
    var style: TokenStyle { get }
}

protocol Combinable: Accumulable, Stylable {
    
    func combine(with other: Combinable) -> Token?
}

extension Token {
    
    var canMove: Bool { self is Movable }
}
