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
    func create(at location: Location) -> Avatar {
        let avatar = Avatar(location: location)
        place(token: avatar, at: location)
        return avatar
    }
}

struct AvatarLayerView: BoardLayerView {
    
    @ObservedObject
    var layer: AvatarLayer
    
    let unitSize: CGFloat
    
    var body: some View {
        ForEach(layer.tokens, id: \.self) {
            AvatarView(avatar: $0)
                .frame(width: unitSize, height: unitSize)
                .position(position(for: $0.location))
        }
    }
}
