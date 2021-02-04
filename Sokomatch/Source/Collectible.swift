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
    
    let id = UUID()
    let type: TokenType = .collectible
    let subtype: CollectibleType
    
    var value = 1
    var location: Location = .zero
    
    init(subtype: CollectibleType) {
        self.subtype = subtype
    }
}

extension Collectible: Interactable {
    
    func interact(with other: Interactable) -> Token? {
        guard other.type == .avatar else {
            return nil
        }
        return add(-value)
    }
}
