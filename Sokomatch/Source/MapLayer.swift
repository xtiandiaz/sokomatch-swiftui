//
//  MapLayer.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 7.2.2021.
//  Copyright © 2021 Berilio. All rights reserved.
//

import SwiftUI
import Emerald

class MapLayer: BoardLayer<Tile> {
    
    func create(tile: TileType, at location: Location) {
        place(token: Tile(subtype: tile), at: location)
    }
    
    override func isAvailable(location: Location) -> Bool {
        !isObstructive(location: location)
    }
    
    override func isObstructive(location: Location) -> Bool {
        switch self[location]?.subtype {
        case .bound, .block: return true
        default: return false
        }
    }
}

struct MapLayerView: View {
    
    @ObservedObject
    var layer: MapLayer
    
    var body: some View {
        ForEach(layer.spots, id: \.self) {
            TileView(tile: $0.token)
                .position(layer.position(for: $0.location))
                .frame(width: layer.unitSize, height: layer.unitSize)
        }
    }
}
