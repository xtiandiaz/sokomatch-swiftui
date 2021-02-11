//
//  AccessLayer.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 11.2.2021.
//  Copyright © 2021 Berilio. All rights reserved.
//

import SwiftUI
import Emerald

class AccessLayer: BoardLayer<Doorway> {
    
    func unlock(withKey key: UUID) {
        guard
            var doorway = (tokens.first { $0.key == key }),
            let location = self[doorway]
        else {
            return
        }
        
        objectWillChange.send()
        
        doorway.isLocked = false
        place(token: doorway, at: location)
    }
    
    func create(withKey key: UUID, at location: Location) {
        place(token: Doorway(key: key), at: location)
    }
    
    override func isObstructive(location: Location) -> Bool {
        self[location]?.isLocked == true
    }
}

struct AccessLayerView: View {
    
    @ObservedObject
    var layer: AccessLayer
    
    var body: some View {
        ForEach(layer.spots, id: \.self) {
            DoorwayView(doorway: $0.token)
                .position(layer.position(for: $0.location))
                .frame(width: layer.unitSize, height: layer.unitSize)
        }
    }
}
