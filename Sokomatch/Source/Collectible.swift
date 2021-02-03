//
//  Collectible.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 3.2.2021.
//  Copyright © 2021 Berilio. All rights reserved.
//

import Foundation
import Emerald

enum CollectibleType {
    case coin
}

struct Collectible: Token {
    
    var id = UUID()
    var type: TokenType = .collectible
    var subtype: CollectibleType
    var value = 1
    
    var location: Location
    
    init(location: Location, subtype: CollectibleType) {
        self.location = location
        self.subtype = subtype
    }
}

extension Collectible: Interactable {
    
    func interact(with other: Interactable) -> Token? {
        guard other.type == .actor else {
            return nil
        }
        return add(-value)
    }
}
