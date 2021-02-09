//
//  TerrainLayer.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 7.2.2021.
//  Copyright © 2021 Berilio. All rights reserved.
//

import SwiftUI
import Emerald

class TerrainLayer: BoardLayer<Wall> {
    
    @discardableResult
    override func create(at location: Location) -> Wall {
        let wall = Wall()
        place(token: wall, at: location)
        return wall
    }
}

struct TerrainLayerView: View {
    
    @ObservedObject
    var layer: TerrainLayer
    
    var body: some View {
        ForEach(layer.tokenLocations, id: \.self) {
            WallView()
                .position(layer.position(for: $0.location))
                .frame(width: layer.unitSize, height: layer.unitSize)
        }
    }
}
