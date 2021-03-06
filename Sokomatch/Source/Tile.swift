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
        default: return .map
        }
    }
    
    let collisionMask: [TokenCategory] = [.boundary]

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
                    .font(.title)
                    .foregroundColor(Color.black).opacity(0.25)
            }
        case .pit:
            Color.clear
//            Color.ground.mask(
//                Color.white.overlay(Color.black.cornerRadius(4).padding(1))
//                    .compositingGroup()
//                    .luminanceToAlpha())
        case .bridge:
//            Color.ground.overlay(RoundedRectangle(cornerRadius: 4).strokeBorder(Color.black, lineWidth: 1))
            Color.ground.cornerRadius(4).padding(1)
        case .passageway(let edge):
            passageway(edge: edge)
        case .door(let locked, let edge):
            ZStack {
                if let edge = edge {
                    passageway(edge: edge)
                } else {
                    Color.ground
                }
                
                if locked {
                    Image(systemName: "lock.fill").resizableToFit().scaleEffect(0.4)
                }
            }
        }
    }
    
    // MARK: Private
    
    private func passageway(edge: Edge) -> some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.ground.opacity(0), Color.ground]),
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

// MARK: Codable

extension TileType: Codable {
    
    enum CodingKeys: CodingKey {
        case bound, floor
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let key = container.allKeys.first
        
        switch key {
        case .bound: self = .bound
        case .floor: self = .floor
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
        case .bound: try container.encode(true, forKey: .bound)
        case .floor: try container.encode(true, forKey: .floor)
        default: break
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
