//
//  MovableLayer.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 6.3.2021.
//  Copyright © 2021 Berilio. All rights reserved.
//

import SwiftUI

class MovableLayer: BoardLayer<Movable> {
    
    func createAvatar(at location: Location) -> Avatar {
        let avatar = Avatar(location: location)
        place(token: avatar, at: location)
        return avatar
    }
    
    func createBlock(at location: Location) {
        place(token: Movable(type: .block, location: location))
    }
    
    override func place(token: Movable, at location: Location) {
        super.place(token: token, at: location)
        
        token.location = location
    }
}

struct MovableLayerView: BoardLayerView {
    
    @ObservedObject
    var layer: MovableLayer
    
    let unitSize: CGFloat
    
    var body: some View {
        ForEach(layer.tokens) {
            token in
            Group {
                switch token {
                case let avatar as Avatar:
                    AvatarView(avatar: avatar)
                default:
                    MovableView(movable: token)
                }
            }
            .frame(width: unitSize, height: unitSize)
            .position(position(for: token.location))
        }
    }
}

