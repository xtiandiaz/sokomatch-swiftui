//
//  Actor.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 19.12.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import SwiftUI
import Emerald

struct Actor: Token, Movable {
    
    let id = UUID()
    let type: TokenType = .actor
    var location: Location
    var value = 1
    
    init(location: Location) {
        self.location = location
    }
}

extension Actor: Interactable {
    
    func interact(with other: Interactable) -> Token? {
        switch other.type {
        case .trigger:
            return other.interact(with: self)
        default:
            return nil
        }
    }
}

struct ActorView: View {
    
    var body: some View {
        Circle()
            .fill(Color.white)
    }
}
