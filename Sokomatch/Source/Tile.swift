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
    case block
    case abyss
    case passageway(Edge)
}

struct Tile: Token, Hashable, Identifiable {
    
    let id = UUID()
    let type: TokenType = .tile
    let subtype: TileType
    
    init(subtype: TileType) {
        self.subtype = subtype
    }
}

extension Tile: Equatable {
    
    static func == (lhs: Tile, rhs: Tile) -> Bool {
        lhs.id == rhs.id
    }
}

struct TileView: View {

    let tile: Tile

    var body: some View {
        switch tile.subtype {
        case .bound:
            Color.clear
        case .floor:
            Color.purple.opacity(0.25)
        case .block:
            Color.purple.opacity(0.5)
        case .abyss:
            Color.black
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
