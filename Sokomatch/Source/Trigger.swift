//
//  Trigger.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 20.12.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import SwiftUI

enum TriggerType {
    
    case event(BoardEvent)
    case lock(key: UUID)
    case `switch`(emblem: Emblem, enabled: Bool, points: [Location])
}

struct Trigger: Layerable {
    
    let id: UUID
    let category: TokenCategory = .trigger
    let type: TriggerType
    let location: Location
    
    let collisionMask: [TokenCategory] = []
    
    var interactionMask: [TokenCategory] {
        switch type {
        case .switch(_, let enabled, _) where enabled:
            return []
        default:
            return [.avatar]
        }
    }
    
    init(type: TriggerType, location: Location) {
        self.type = type
        self.location = location
        id = UUID()
    }
    
    func affect(with other: Token) -> Trigger? {
        return self
    }
}

struct TriggerView: View {
    
    let trigger: Trigger
    let unitSize: CGFloat
    
    var body: some View {
        switch trigger.type {
        case .switch(let emblem, let enabled, _):
            ZStack {
                Circle().fill(emblem.color).brightness(-0.5)
                Group {
                    if !enabled {
                        Circle().fill(emblem.color)
                    }
                    
                    emblem.icon(withSize: unitSize)
                        .foregroundColor(emblem.color)
                        .if(!enabled) { $0.brightness(-0.5) }
                        .scaleEffect(0.5)
                }
                .if(!enabled) { $0.offset(x: 0, y: -.xxs) }
            }
            .scaleEffect(0.5)
        default:
            EmptyView()
        }
    }
}

// MARK: - Codable

extension TriggerType: Codable {
    
    enum CodingKeys: String, CodingKey {
        case event, lock, `switch`
    }
    
    enum SwitchKeys: String, CodingKey {
        case emblem, enabled, points
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        switch container.allKeys.first {
        case .event:
            self = .event(try container.decode(BoardEvent.self, forKey: .event))
        case .lock:
            self = .lock(key: try container.decode(UUID.self, forKey: .lock))
        case .switch:
            let `switch` = try container.nestedContainer(keyedBy: SwitchKeys.self, forKey: .switch)
            self = .switch(
                emblem: try `switch`.decode(Emblem.self, forKey: .emblem),
                enabled: try `switch`.decode(Bool.self, forKey: .enabled),
                points: try `switch`.decode([Location].self, forKey: .points)
            )
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
        case .switch(let emblem, let enabled, let points):
            var `switch` = container.nestedContainer(keyedBy: SwitchKeys.self, forKey: .switch)
            try `switch`.encode(emblem, forKey: .emblem)
            try `switch`.encode(enabled, forKey: .enabled)
            try `switch`.encode(points, forKey: .points)
        }
    }
}

extension Trigger: Codable {
    
    enum CodingKeys: String, CodingKey {
        case id, type, location
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(UUID.self, forKey: .id)
        type = try container.decode(TriggerType.self, forKey: .type)
        location = try container.decode(Location.self, forKey: .location)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
        try container.encode(location, forKey: .location)
    }
}
