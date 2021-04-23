//
//  Wall.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 10.3.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import SwiftUI

enum TileType: Hashable {
    
    case bound
    case floor
    case stickyFloor
    case pit
    case bridge
    case passageway(Edge)
    case door(locked: Bool, edge: Edge?)
    case block(emblem: Emblem, enabled: Bool)
}

struct Tile: Layerable {
    
    let id = UUID()
    let type: TileType
    
    var location: Location
    
    var category: TokenCategory {
        switch type {
        case .bound: return .boundary
        case .pit, .stickyFloor: return .trap
        case .door(let locked, _): return locked ? .boundary : .map
        case .block(_, let enabled): return enabled ? .boundary : .map
        default: return .map
        }
    }
    
    let collisionMask: [TokenCategory] = []

    var interactionMask: [TokenCategory] {
        switch type {
        case .stickyFloor: return [.movable]
        default: return []
        }
    }
    
    init(type: TileType, location: Location) {
        self.type = type
        self.location = location
    }
    
    func affect(with other: Token) -> Tile? {
        switch type {
        case .pit where other is Movable:
            switch (other as! Movable).type {
            case .block: return Tile(type: .bridge, location: location)
            default: return self
            }
        default: return self
        }
    }
}

struct TileView: View {

    let tile: Tile
    
    let unitSize: CGFloat

    var body: some View {
        switch tile.type {
        case .bound:
            Color.wall.cornerRadius(8, corners: tile.location.corners)
        case .floor:
            Color.ground
        case .stickyFloor:
            ZStack {
                Color.ground
                
                Image(systemName: "circle.grid.3x3.fill")
                    .resizableToFit()
                    .foregroundColor(Color.black.opacity(0.25))
                    .scaleEffect(0.5)
            }
        case .pit:
            Color.black
//            Color.ground.mask(
//                Color.white.overlay(Color.black.cornerRadius(4).padding(1))
//                    .compositingGroup()
//                    .luminanceToAlpha())
        case .bridge:
//            Color.ground.overlay(RoundedRectangle(cornerRadius: 4).strokeBorder(Color.black, lineWidth: 1))
            Color.ground.cornerRadius(4).padding(1)
        case .passageway(let edge):
            passagewayView(edge: edge)
        case .door(let locked, let edge):
            ZStack {
                if let edge = edge {
                    passagewayView(edge: edge)
                } else {
                    Color.ground
                }
                
                if locked {
                    Image(systemName: "lock.fill")
                        .resizableToFit()
                        .foregroundColor(Color.white)
                        .scaleEffect(0.4)
                }
            }
        case .block(let emblem, let enabled):
            ZStack {
                if enabled {
                    emblem.color
                    emblem.icon(withSize: unitSize, weight: .regular)
                        .foregroundColor(emblem.color)
                        .brightness(-0.5)
                        .scaleEffect(0.5)
                } else {
                    Color.ground
                    Group {
                        Rectangle().strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [8]))
                        emblem.icon(withSize: unitSize, weight: .regular)
                            .scaleEffect(0.5)
                    }
                    .foregroundColor(emblem.color.opacity(0.5))
                }
            }
        }
    }
    
    // MARK: Private
    
    private func passagewayView(edge: Edge) -> some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.ground.opacity(0.5), Color.ground]),
            startPoint: edge.gradientStartPoint,
            endPoint: edge.gradientEndPoint)
    }
}

private extension Edge {

    var gradientStartPoint: UnitPoint {
        switch self {
        case .top: return .top
        case .left: return .leading
        case .bottom: return .bottom
        case .right: return .trailing
        }
    }

    var gradientEndPoint: UnitPoint {
        switch self {
        case .top: return .bottom
        case .left: return .trailing
        case .bottom: return .top
        case .right: return .leading
        }
    }
}

// MARK: - Codable

extension TileType: Codable {
    
    enum CodingKeys: String, CodingKey {
        case bound, floor, stickyFloor, pit, bridge, passageway, door, block
    }
    
    enum DoorKeys: String, CodingKey {
        case locked, edge
    }
    
    enum BlockKeys: String, CodingKey {
        case emblem, enabled
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let key = container.allKeys.first
        
        switch key {
        case .bound: self = .bound
        case .floor: self = .floor
        case .stickyFloor: self = .stickyFloor
        case .pit: self = .pit
        case .bridge: self = .bridge
        case .passageway:
            self = .passageway(try container.decode(Edge.self, forKey: .passageway))
        case .door:
            let door = try container.nestedContainer(keyedBy: DoorKeys.self, forKey: .door)
            self = .door(
                locked: try door.decode(Bool.self, forKey: .locked),
                edge: try? door.decode(Edge.self, forKey: .edge))
        case .block:
            let block = try container.nestedContainer(keyedBy: BlockKeys.self, forKey: .block)
            self = .block(
                emblem: try block.decode(Emblem.self, forKey: .emblem),
                enabled: try block.decode(Bool.self, forKey: .enabled))
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
        case .bound: try container.encode(0, forKey: .bound)
        case .floor: try container.encode(0, forKey: .floor)
        case .stickyFloor: try container.encode(0, forKey: .stickyFloor)
        case .pit: try container.encode(0, forKey: .pit)
        case .bridge: try container.encode(0, forKey: .bridge)
        case .passageway(let edge): try container.encode(edge, forKey: .passageway)
        case .door(let locked, let edge):
            var door = container.nestedContainer(keyedBy: DoorKeys.self, forKey: .door)
            try door.encode(locked, forKey: .locked)
            try door.encode(edge, forKey: .edge)
        case .block(let emblem, let enabled):
            var block = container.nestedContainer(keyedBy: BlockKeys.self, forKey: .block)
            try block.encode(emblem, forKey: .emblem)
            try block.encode(enabled, forKey: .enabled)
        }
    }
}

extension Tile: Codable {
    
    enum CodingKeys: String, CodingKey {
        case type, location
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        type = try container.decode(TileType.self, forKey: .type)
        location = try container.decode(Location.self, forKey: .location)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(type, forKey: .type)
        try container.encode(location, forKey: .location)
    }
}
