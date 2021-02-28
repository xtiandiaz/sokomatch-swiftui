//
//  AvatarLayer.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 7.2.2021.
//  Copyright © 2021 Berilio. All rights reserved.
//

import SwiftUI
import Combine

class AvatarLayer: BoardLayer<Avatar> {
    
    var onDeath: AnyPublisher<Bool, Never> {
        deathSubject.eraseToAnyPublisher()
    }
    
    @discardableResult
    func create(at location: Location) -> Avatar {
        let avatar = Avatar(location: location)
        place(token: avatar, at: location)
        return avatar
    }
    
    override func onTokenMorphed(from: Avatar?, to: Avatar?, at: Location) {
        if to == nil {
            deathSubject.send(true)
        }
    }
    
    // MARK: Private
    
    private let deathSubject = PassthroughSubject<Bool, Never>()
}

struct AvatarLayerView: BoardLayerView {
    
    @ObservedObject
    var layer: AvatarLayer
    
    let unitSize: CGFloat
    
    var body: some View {
        ForEach(layer.tokens) {
            AvatarView(avatar: $0)
                .frame(width: unitSize, height: unitSize)
                .position(position(for: $0.location))
        }
    }
}
