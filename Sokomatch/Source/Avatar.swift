//
//  Avatar.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 19.12.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import SwiftUI
import Emerald

struct Avatar: Token, Movable {
    
    let id = UUID()
    let type: TokenType = .avatar
    
    var value = 1
    var location: Location = .zero
}

extension Avatar: Interactable {
    
    func interact(with other: Interactable) -> Token? {
        switch other.type {
        case .doorway:
            return other.interact(with: self)
        case .collectible:
            return self
        default:
            return nil
        }
    }
}

struct AvatarView: View {
    
    var body: some View {
        Circle()
            .fill(Color.white)
    }
}
