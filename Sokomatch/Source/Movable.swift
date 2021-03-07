//
//  Movable.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 6.3.2021.
//  Copyright © 2021 Berilio. All rights reserved.
//

import SwiftUI

enum MovableType: String, Codable {
    case avatar, block
}

class Movable: Layerable, Codable {
    
    let id: UUID
    let type: MovableType
    
    var category: TokenCategory {
        switch type {
        case .avatar: return .avatar
        default: return .movable
        }
    }
    
    @Published
    var location: Location
    
    var collisionMask: [TokenCategory] {
        [.boundary, .movable]
    }
    
    var interactionMask: [TokenCategory] {
        [.trap]
    }
    
    var weight: Int { 1 }
    
    init(type: MovableType, location: Location) {
        self.type = type
        self.location = location
        id = UUID()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(UUID.self, forKey: .id)
        type = try container.decode(MovableType.self, forKey: .type)
        location = try container.decode(Location.self, forKey: .location)
    }
    
    func affect(with other: Token) -> Self? {
        switch other {
        case let tile as Tile where tile.type == .pit:
            return nil
        default:
            return self
        }
    }
    
    func canPush(_ other: Movable) -> Bool {
        other.weight <= weight
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
        try container.encode(location, forKey: .location)
    }
}

struct MovableView: View {
    
    let movable: Movable
    
    var body: some View {
        switch movable.type {
        case .block: Color.block.cornerRadius(4).padding(2)
        default: EmptyView()
        }
    }
}

// MARK: - Codable

extension Movable {
    
    private enum CodingKeys: String, CodingKey {
        case id, type, location
    }
}
