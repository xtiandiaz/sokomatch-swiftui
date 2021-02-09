//
//  AvatarLayer.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 7.2.2021.
//  Copyright © 2021 Berilio. All rights reserved.
//

import SwiftUI
import Emerald

class AvatarLayer: BoardLayer<Avatar> {
    
    @discardableResult
    override func create(at location: Location) -> Avatar {
        let avatar = Avatar(location: location)
        place(piece: avatar, at: location)
        return avatar
    }
    
    override func relocate(piece: Avatar, to destination: Location) {
        super.relocate(piece: piece, to: destination)
        
        piece.location = destination
    }
}

struct AvatarLayerView: View {
    
    @ObservedObject
    var layer: AvatarLayer
    
    var body: some View {
        ForEach(layer.pieces, id: \.self) {
            AvatarView(avatar: $0, positionForLocation: layer.position(for:))
                .frame(width: layer.unitSize, height: layer.unitSize)
        }
    }
}
