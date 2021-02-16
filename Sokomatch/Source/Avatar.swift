//
//  Avatar.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 19.12.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import SwiftUI
import Emerald

class Avatar: ObservableObject, Piece {
    
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
    
    func canInteract(with other: Token) -> Bool {
        switch other {
        case is Collectible: return true
        case let tile as Tile: return tile.type == .pit
        default: return false
        }
    }
    
    func interact(with other: Token) -> Self? {
        switch other {
        case let tile as Tile where tile.type == .pit:
            return nil
        default:
            return self
        }
    }
    
    // MARK: Private
    
    private var keys = Set<UUID>()
}

extension Avatar: Equatable {
    
    static func ==(lhs: Avatar, rhs: Avatar) -> Bool {
        lhs.id == rhs.id
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

// MARK: - Codable

extension Avatar: Codable {
    
    enum CodingKeys: String, CodingKey {
        case location, isFocused
    }
    
    func encode(to encoder: Encoder) throws {
    }
}
