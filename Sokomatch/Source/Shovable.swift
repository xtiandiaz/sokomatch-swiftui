//
//  Shovable.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 15.2.2021.
//  Copyright © 2021 Berilio. All rights reserved.
//

import SwiftUI

enum ShovableType: String, Codable {
    case block
}

struct Shovable: Layerable {
    
    let id = UUID()
    let token: TokenType = .shovable
    let type: ShovableType
    
    var location: Location
    var isInvalidated = false
    
    init(type: ShovableType, location: Location) {
        self.type = type
        self.location = location
    }
    
    func canInteract(with other: Token) -> Bool {
        switch other {
        case let tile as Tile where tile.type == .pit: return true
        default: return false
        }
    }
    
    func interact(with other: Token) -> Shovable? {
        switch other {
        case let tile as Tile where tile.type == .pit: return nil
        default: return self
        }
    }
}

// MARK: - Codable

extension Shovable: Codable {
    
    enum CodingKeys: String, CodingKey {
        case type, location
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        type = try container.decode(ShovableType.self, forKey: .type)
        location = try container.decode(Location.self, forKey: .location)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(type, forKey: .type)
    }
}

struct ShovableView: View {
    
    let shovable: Shovable
    
    var body: some View {
        Color.block.cornerRadius(4).padding(2)
            .transition(.asymmetric(insertion: .identity, removal: .opacity))
    }
}
