//
//  MapLayer.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 7.2.2021.
//  Copyright © 2021 Berilio. All rights reserved.
//

import SwiftUI

class MapLayer: BoardLayer<Tile> {
    
    func create(_ tile: TileType, at location: Location) {
        place(token: Tile(type: tile, location: location))
    }
    
    func activate(locations: [Location], withEmblem emblem: Emblem) {
        locations.forEach {
            if self[$0]?.type == .block(emblem: emblem, enabled: false) {
                place(token: Tile(type: .block(emblem: emblem, enabled: true), location: $0))
            }
        }
    }
    
    override func isAvailable(location: Location) -> Bool {
        switch self[location]?.type {
        case nil, .floor: return true
        default: return false
        }
    }
}

struct MapLayerView: BoardLayerView {
    
    @ObservedObject
    var layer: MapLayer
    
    let unitSize: CGFloat
    
    var body: some View {
        ForEach(layer.tokens) {
            TileView(tile: $0, unitSize: unitSize)
                .frame(width: unitSize, height: unitSize)
                .position(position(for: $0.location))
        }
    }
}
