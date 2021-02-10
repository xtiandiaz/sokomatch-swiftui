//
//  MechanismLayer.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 10.2.2021.
//  Copyright © 2021 Berilio. All rights reserved.
//

import SwiftUI
import Emerald

class MechanismLayer: BoardLayer<Mechanism> {
    
    func create(_ subtype: MechanismType, at location: Location) {
        place(token: Mechanism(subtype: subtype), at: location)
    }
}

struct MechanismLayerView: View {
    
    @ObservedObject
    var layer: MechanismLayer
    
    var body: some View {
        ForEach(layer.spots, id: \.self) {
            MechanismView(mechanism: $0.token)
                .position(layer.position(for: $0.location))
                .frame(width: layer.unitSize, height: layer.unitSize)
        }
    }
}
