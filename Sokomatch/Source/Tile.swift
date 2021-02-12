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
    case block
    case abyss
    case passageway(Edge)
}

struct Tile: Token, Hashable, Identifiable {
    
    let id = UUID()
    let token: TokenType = .map
    let type: TileType
    
    init(type: TileType) {
        self.type = type
    }
}

extension Tile: Equatable {
    
    static func == (lhs: Tile, rhs: Tile) -> Bool {
        lhs.id == rhs.id
    }
}

extension Tile: Interactable {
    
    func canInteract(with other: Interactable) -> Bool {
        other is Avatar && type == .stickyFloor
    }
    
    func interact(with other: Interactable) -> Tile? {
        self
    }
}

struct TileView: View {

    let tile: Tile

    var body: some View {
        switch tile.type {
        case .bound:
            Color.clear
        case .floor:
            Color.purple.opacity(0.25)
        case .stickyFloor:
            ZStack {
                Color.purple.opacity(0.25)
                
                Image(systemName: "circle.grid.3x3.fill")
                    .font(.title)
                    .foregroundColor(Color.black).opacity(0.25)
            }
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
