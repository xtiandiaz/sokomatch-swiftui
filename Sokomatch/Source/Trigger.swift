//
//  Trigger.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 20.12.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import SwiftUI
import Emerald

enum TriggerType {
    
    case event(BoardEvent), lock(key: UUID)
}

struct Trigger: Layerable {
    
    let id = UUID()
    let token: TokenType = .trigger
    let type: TriggerType
    
    var location: Location
    
    init(type: TriggerType, location: Location) {
        self.type = type
        self.location = location
    }
    
    func canInteract(with other: Token) -> Bool {
        other is Avatar
    }
    
    func interact(with other: Token) -> Trigger? {
        guard let avatar = other as? Avatar else {
            return self
        }
        
        switch type {
        case .lock(let key):
            return avatar.hasKey(key) ? nil : self
        default:
            return self
        }
    }
}

// MARK: - Codable

extension TriggerType: Codable {
    
    enum CodingKeys: String, CodingKey {
        case event, lock
    }
    
    enum Error: Swift.Error {
        case unknownValue
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        switch container.allKeys.first {
        case .event:
            self = .event(try container.decode(BoardEvent.self, forKey: .event))
        case .lock:
            self = .lock(key: try container.decode(UUID.self, forKey: .lock))
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
        case .event(let event):
            try container.encode(event, forKey: .event)
        case .lock(let key):
            try container.encode(key, forKey: .lock)
        }
    }
}

extension Trigger: Codable {
    
    enum CodingKeys: String, CodingKey {
        case type, location
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        type = try container.decode(TriggerType.self, forKey: .type)
        location = try container.decode(Location.self, forKey: .location)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(type, forKey: .type)
    }
}
