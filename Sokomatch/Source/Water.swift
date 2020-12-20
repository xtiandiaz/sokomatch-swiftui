//
//  Blob.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 18.2.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import SwiftUI
import Emerald

struct Water: Token, Movable {
    
    let id = UUID()
    let type: TokenType = .water
    var location: Location
    var value = 1
}

extension Water: Interactable {
    
    func interact(with other: Interactable) -> Token? {
        switch other {
        case is Fire:
            return other.interact(with: self)
        case is Water:
            return add(other.value)
        case is Target:
            return other.interact(with: self)
        default:
            return nil
        }
    }
}
