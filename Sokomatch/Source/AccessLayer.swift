//
//  AccessLayer.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 11.2.2021.
//  Copyright © 2021 Berilio. All rights reserved.
//

import SwiftUI
import Emerald

class AccessLayer: BoardLayer<Access> {
    
    func unlock(withKey key: UUID) {
        guard
            var access = (tokens.first { $0.key == key }),
            let location = self[access]
        else {
            return
        }
        
        objectWillChange.send()
        
        access.isLocked = false
        place(token: access, at: location)
    }
    
    func create(withKey key: UUID, at location: Location) {
        place(token: Access(key: key, location: location))
    }
    
    override func isObstructive(location: Location, for token: Token?) -> Bool {
        self[location]?.isLocked == true
    }
}

struct AccessLayerView: BoardLayerView {
    
    @ObservedObject
    var layer: AccessLayer
    
    let unitSize: CGFloat
    
    var body: some View {
        ForEach(layer.tokens) {
            AccessView(access: $0)
                .frame(width: unitSize, height: unitSize)
                .position(position(for: $0.location))
        }
    }
}
