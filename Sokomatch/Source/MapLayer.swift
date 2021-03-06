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
            TileView(tile: $0)
                .frame(width: unitSize, height: unitSize)
                .position(position(for: $0.location))
        }
    }
}
