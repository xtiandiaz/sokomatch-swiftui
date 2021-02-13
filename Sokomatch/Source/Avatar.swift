//
//  Avatar.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 19.12.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import SwiftUI
import Emerald

class Avatar: ObservableObject, Piece, Movable {
    
    let id = UUID()
    let token: TokenType = .avatar
    
    @Published
    var location: Location
    @Published
    var isFocused = true
    
    init(location: Location) {
        self.location = location
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        location = (try? container.decode(Location.self, forKey: .location)) ?? .zero
        isFocused = (try? container.decode(Bool.self, forKey: .isFocused)) ?? false
    }
    
    func addKey(_ key: UUID) {
        keys.insert(key)
    }
    
    func hasKey(_ key: UUID) -> Bool {
        keys.contains(key)
    }
    
    // MARK: Private
    
    private var keys = Set<UUID>()
}

extension Avatar: Codable {
    
    enum CodingKeys: String, CodingKey {
        case location, isFocused
    }
    
    func encode(to encoder: Encoder) throws {
        var container = try encoder.container(keyedBy: CodingKeys.self)
        
        
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
    
    var body: some View {
        Circle()
            .fill(avatar.isFocused ? Color.white : Color.black)
            .overlay(Circle().strokeBorder(Color.white, lineWidth: 2))
    }
}
