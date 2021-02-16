//
//  Wall.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 10.3.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import SwiftUI
import Emerald

enum TileType: Hashable {
    
    case bound
    case floor
    case stickyFloor
    case pit
    case bridge
    case passageway(Edge)
}

struct Tile: Layerable {
    
    let id = UUID()
    let token: TokenType = .map
    let type: TileType
    
    var location: Location
    
    init(type: TileType, location: Location) {
        self.type = type
        self.location = location
    }
    
    func canInteract(with other: Token) -> Bool {
        switch type {
        case .stickyFloor, .pit: return true
        default: return false
        }
    }
    
    func interact(with other: Token) -> Tile? {
        switch type {
        case .pit:
            switch other {
            case let shovable as Shovable where shovable.type == .block:
                return Tile(type: .bridge, location: location)
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
            Color.purple.opacity(0.4)
        case .floor:
            Color.purple.opacity(0.25)
        case .stickyFloor:
            ZStack {
                Color.purple.opacity(0.25)
                
                Image(systemName: "circle.grid.3x3.fill")
                    .font(.title)
                    .foregroundColor(Color.black).opacity(0.25)
            }
        case .pit:
            Color.black
        case .bridge:
            Color.purple.opacity(0.25).cornerRadius(4).padding(2)
        case .passageway(let edge):
            LinearGradient(
                gradient: Gradient(colors: [Color.purple.opacity(0), Color.purple.opacity(0.25)]),
                startPoint: edge.gradientStartPoint,
                endPoint: edge.gradientEndPoint)
        }
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
