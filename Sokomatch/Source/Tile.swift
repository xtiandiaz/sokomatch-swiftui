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
    case block
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
        case .stickyFloor: return true
        case .pit:
            switch other {
            case let avatar as Avatar: return avatar.mode != .ghost
            default: return true
            }
        default: return false
        }
    }
    
    func interact(with other: Token) -> Tile? {
        switch type {
        case .pit where other is Tile:
            switch (other as! Tile).type {
            case .block: return Tile(type: .bridge, location: location)
            default: return self
            }
        case .block where other is Tile:
            return (other as! Tile).type  == .pit ? nil : self
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
        case .block:
            Color.block.cornerRadius(4).padding(2)
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
            LinearGradient(
                gradient: Gradient(colors: [Color.ground.opacity(0), Color.ground]),
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
