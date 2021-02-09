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
        place(token: avatar, at: location)
        return avatar
    }
    
    override func relocate(token: Avatar, to destination: Location) {
        super.relocate(token: token, to: destination)
        
        token.location = destination
    }
}

struct AvatarLayerView: View {
    
    @ObservedObject
    var layer: AvatarLayer
    
    var body: some View {
        ForEach(layer.tokens, id: \.self) {
            AvatarView(avatar: $0, positionForLocation: layer.position(for:))
                .frame(width: layer.unitSize, height: layer.unitSize)
        }
    }
}
