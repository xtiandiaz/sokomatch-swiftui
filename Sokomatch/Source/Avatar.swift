//
//  Avatar.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 19.12.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import SwiftUI

final class Avatar: Movable, ObservableObject {
    
    enum Mode {
        case normal, mighty, ghost
    }
    
    enum Ability {
        case magnesis
    }
    
    @Published
    var mode: Avatar.Mode = .normal
     
    override var collisionMask: [TokenCategory] {
        switch mode {
        case .ghost: return [.boundary]
        default: return [.boundary, .movable]
        }
    }
    
    override var interactionMask: [TokenCategory] {
        switch mode {
        case .ghost: return [.collectible, .trigger]
        default: return [.collectible, .trap, .trigger]
        }
    }
    
    init(location: Location) {
        super.init(type: .avatar, location: location)
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
    
    deinit {
        print("dead")
    }
    
    func addKey(_ key: UUID) {
        keys.insert(key)
    }
    
    func hasKey(_ key: UUID) -> Bool {
        keys.contains(key)
    }
    
    override func affect(with other: Token) -> Self? {
        switch other {
        case let tile as Tile where tile.type == .pit && mode != .ghost:
            return nil
        default:
            return self
        }
    }
    
    // MARK: Private
    
    private var keys = Set<UUID>()
}

struct AvatarView: View {
    
    @ObservedObject
    var avatar: Avatar
    @State
    private var propellerRotation: Double = 0
    
    var body: some View {
        ZStack {
            Circle()
                .padding(1)
                .if(avatar.mode == .ghost) { $0.opacity(0.5) }
                .if(avatar.mode == .mighty) { $0.shadow(color: Color.white, radius: 20, x: 0, y: 0) }
                .zIndex(0)
            
//            if avatar.isHovering {
//                Propeller(petalCount: 5, petalBreadth: Angle(degrees: 30))
//                    .fill(Color.black)
//                    .scaleEffect(0.75)
//                    .rotationEffect(Angle(degrees: propellerRotation))
//                    .animation(Animation.linear(duration: 0.5).repeatForever(autoreverses: false))
//                    .transition(AnyTransition.scale.animation(.default))
//                    .zIndex(1)
//                    .onReceive(avatar.$isHovering) {
//                        propellerRotation = $0 ? 360 : 0
//                    }
//            }
        }
        .transition(AnyTransition.opacity.animation(.linear(duration: 0.2)))
    }
}

// MARK: - Codable

