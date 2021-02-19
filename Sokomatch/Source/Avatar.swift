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
    @Published
    var isHovering = false
    
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
        case let tile as Tile: return tile.type == .pit && !isHovering
        default: return false
        }
    }
    
    func interact(with other: Token) -> Self? {
        switch other {
        case let tile as Tile where tile.type == .pit && !isHovering:
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
    @State
    private var propellerRotation: Double = 0
    
    var body: some View {
        ZStack {
            Circle()
                .fill(avatar.isFocused ? Color.white : Color.black)
//                .overlay(Circle().strokeBorder(Color.white, lineWidth: 2))
                .padding(1)
                .scaleEffect(avatar.isHovering ? 1.1 : 1)
                .zIndex(0)
            
            if avatar.isHovering {
                Propeller(petalCount: 5, petalBreadth: Angle(degrees: 30))
                    .fill(Color.black)
                    .scaleEffect(0.75)
                    .rotationEffect(Angle(degrees: propellerRotation))
                    .animation(Animation.linear(duration: 0.5).repeatForever(autoreverses: false))
                    .transition(AnyTransition.scale.animation(.default))
                    .zIndex(1)
                    .onReceive(avatar.$isHovering) {
                        propellerRotation = $0 ? 360 : 0
                    }
            }
        }
        .transition(AnyTransition.opacity.animation(.linear(duration: 0.2)))
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
