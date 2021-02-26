//
//  BoardEvent.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 12.2.2021.
//  Copyright © 2021 Berilio. All rights reserved.
//

import Foundation

enum BoardEvent {
    
    case unlocked(key: UUID)
    case collected(Collectible)
    case reachedGoal
    case death
}

// MARK: - Codable

extension BoardEvent: Codable {
    
    enum CodingKeys: String, CodingKey {
        case unlocked, collected, reachedGoal
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        switch container.allKeys.first {
        case .unlocked:
            self = .unlocked(key: try container.decode(UUID.self, forKey: .unlocked))
        case .collected:
            self = .collected(try container.decode(Collectible.self, forKey: .collected))
        case .reachedGoal:
            self = .reachedGoal
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
        case .unlocked(let key):
            try container.encode(key, forKey: .unlocked)
        case .collected(let collectible):
            try container.encode(collectible, forKey: .collected)
        case .reachedGoal:
            try container.encode(true, forKey: .reachedGoal)
        default:
            break
        }
    }
}
