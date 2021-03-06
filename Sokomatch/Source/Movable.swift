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

class Movable: Layerable {
    
    let id = UUID()
    let category: TokenCategory
    let type: MovableType
    
    @Published
    var location: Location
    
    var collisionMask: [TokenCategory] { [] }
    var interactionMask: [TokenCategory] { [] }
    
    init(type: MovableType, location: Location) {
        self.type = type
        self.location = location
        
        category = {
            switch type {
            case .avatar: return .avatar
            default: return .movable
            }
        }()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        type = try container.decode(MovableType.self, forKey: .type)
        location = try container.decode(Location.self, forKey: .location)
        category = try container.decode(TokenCategory.self, forKey: .category)
    }
    
    func affect(with other: Token) -> Self? {
        return self
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

extension Movable: Codable {
    
    enum CodingKeys: String, CodingKey {
        case type, location, category
    }
    
    func encode(to encoder: Encoder) throws {
        
    }
}
