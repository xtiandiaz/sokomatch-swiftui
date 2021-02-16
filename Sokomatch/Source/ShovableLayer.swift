//
//  ShovableLayer.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 15.2.2021.
//  Copyright © 2021 Berilio. All rights reserved.
//

import SwiftUI

class ShovableLayer: BoardLayer<Shovable> {
    
    func create(_ type: ShovableType, at location: Location) {
        place(token: Shovable(type: type, location: location), at: location)
    }
}

struct ShovableLayerView: BoardLayerView {
    
    @ObservedObject
    var layer: ShovableLayer
    
    let unitSize: CGFloat
    
    var body: some View {
        ForEach(layer.tokens) {
            ShovableView(shovable: $0)
                .frame(width: unitSize, height: unitSize)
                .position(position(for: $0.location))
        }
    }
}
