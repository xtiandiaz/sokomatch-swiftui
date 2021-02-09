//
//  Avatar.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 19.12.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import SwiftUI
import Emerald

class Avatar: ObservableObject, Token, Movable, Identifiable, Hashable {
    
    let id = UUID()
    let type: TokenType = .avatar
    
    @Published
    var location: Location
    @Published
    var isFocused = true
    
    var value = 1
    
    init(location: Location) {
        self.location = location
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Avatar: Equatable {
    
    static func ==(lhs: Avatar, rhs: Avatar) -> Bool {
        lhs.id == rhs.id
    }
}

extension Avatar: Interactable {
    
    func canInteract(with other: Interactable) -> Bool {
        switch other {
        case is Collectible: return true
        default: return false
        }
    }
    
    func interact(with other: Interactable) -> Self? {
        self
    }
}

struct AvatarView: View {
    
    @ObservedObject
    var avatar: Avatar
    
    let positionForLocation: (Location) -> CGPoint
    
    var body: some View {
        Circle()
            .fill(avatar.isFocused ? Color.white : Color.black)
            .overlay(Circle().strokeBorder(Color.white, lineWidth: 2))
            .position(positionForLocation(avatar.location))
    }
}
