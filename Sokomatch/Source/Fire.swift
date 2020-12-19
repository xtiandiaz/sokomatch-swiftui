//
//  Fire.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 8.3.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import SwiftUI
import Emerald

struct Fire: Token, Movable {
    
    let id = UUID()
    let type: TokenType = .fire
    var location: Location
    var value = 1
    
    init(location: Location) {
        self.location = location
    }
}

extension Fire: Interactable {
    
    func interact(with other: Interactable) -> Token? {
        switch other {
        case is Water:
            return value < other.value ? other.add(-value) : add(-other.value)
        case is Fire:
            return add(other.value)
        case is Target:
            return other.interact(with: self)
        default:
            return self
        }
    }
}

struct FireView: View {
    
    var body: some View {
        Circle()
            .fill(Color.orange)
    }
}
