//
//  Collectible.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 3.2.2021.
//  Copyright © 2021 Berilio. All rights reserved.
//

import SwiftUI
import Emerald

enum CollectibleType {
    
    case coin(value: Int), key
}

extension CollectibleType: Codable {
    
    enum CodingKeys: CodingKey {
        case coin, key
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        switch container.allKeys.first {
        case .coin:
            self = .coin(value: try container.decode(Int.self, forKey: .coin))
        case .key:
            self = .key
        default:
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: container.codingPath,
                    debugDescription: "Unable to decode \(Self.self)"
                )
            )
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .coin(let value):
            try container.encode(value, forKey: .coin)
        case .key:
            try container.encode(true, forKey: .key)
        }
    }
}

struct Collectible: Piece {
    
    let id = UUID()
    let token: TokenType = .collectible
    let type: CollectibleType
    
    init(type: CollectibleType) {
        self.type = type
    }
}

extension Collectible: Codable {
    
    enum CodingKeys: String, CodingKey {
        case type, value
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        type = try container.decode(CollectibleType.self, forKey: .type)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(type, forKey: .type)
    }
}

extension Collectible: Interactable {
    
    func canInteract(with other: Interactable) -> Bool {
        other is Avatar
    }
    
    func interact(with other: Interactable) -> Collectible? {
        other is Avatar ? nil : self
    }
}

struct CollectibleView: View {
    
    let collectible: Collectible
    
    var body: some View {
        switch collectible.type {
        case .coin:
            Circle().fill(Color.yellow).scaleEffect(0.25)
        case .key:
            Image(systemName: "key.fill")
        }
    }
}
