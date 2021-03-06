//
//  MovableLayer.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 6.3.2021.
//  Copyright © 2021 Berilio. All rights reserved.
//

import SwiftUI

class MovableLayer: BoardLayer<Movable> {
    
    var avatars: [Avatar] {
        Array(_avatars)
    }
    
    override init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        _avatars = Set(try container.decode([Avatar].self, forKey: .avatars))
        for avatar in _avatars {
            place(token: avatar)
        }
        
        for other in try container.decode([Movable].self, forKey: .others) {
            place(token: other)
        }
    }
    
    func createAvatar(at location: Location) -> Avatar {
        let avatar = Avatar(location: location)
        place(token: avatar, at: location)
        _avatars.insert(avatar)
        return avatar
    }
    
    func createBlock(at location: Location) {
        place(token: Movable(type: .block, location: location))
    }
    
    override func place(token: Movable, at location: Location) {
        super.place(token: token, at: location)
        
        token.location = location
    }
    
    override func onTokenChanged(from: Movable, to: Movable?, at location: Location) {
        if to == nil, let avatar = from as? Avatar {
            _avatars.remove(avatar)
        }
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(avatars, forKey: .avatars)
        try container.encode(tokens.filter { $0.type != .avatar }, forKey: .others)
    }
    
    // MARK: Private
    
    private var _avatars = Set<Avatar>()
}

struct MovableLayerView: BoardLayerView {
    
    @ObservedObject
    var layer: MovableLayer
    
    let unitSize: CGFloat
    
    var body: some View {
        ForEach(layer.tokens) {
            token in
            Group {
                switch token {
                case let avatar as Avatar:
                    AvatarView(avatar: avatar)
                default:
                    MovableView(movable: token)
                }
            }
            .frame(width: unitSize, height: unitSize)
            .position(position(for: token.location))
            .id(token.id)
        }
    }
}

// MARK: - Codable

extension MovableLayer {
    
    enum CodingKeys: String, CodingKey {
        case id, avatars, others
    }
}
