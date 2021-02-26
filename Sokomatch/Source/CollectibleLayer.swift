//
//  CollectibleLayer.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 7.2.2021.
//  Copyright © 2021 Berilio. All rights reserved.
//

import SwiftUI
import Combine
import Emerald

class CollectibleLayer: BoardLayer<Collectible> {
    
    var onCollected: AnyPublisher<Collectible, Never> {
        collectibleSubject.eraseToAnyPublisher()
    }
    
    @discardableResult
    func create(_ type: CollectibleType, at location: Location) -> Collectible {
        let collectible = Collectible(type: type, location: location)
        place(token: collectible)
        return collectible
    }
    
    override func onTokenChanged(from: Collectible?, to: Collectible?, at location: Location) {
        if let collectible = from, to == nil {
            collectibleSubject.send(collectible)
        }
    }
    
    override func isObstructive(location: Location, for token: Token?) -> Bool {
        false
    }
    
    // MARK: Private
    
    private let collectibleSubject = PassthroughSubject<Collectible, Never>()
}

struct CollectibleLayerView: BoardLayerView {
    
    @ObservedObject
    var layer: CollectibleLayer
    
    let unitSize: CGFloat
    
    var body: some View {
        ForEach(layer.tokens) {
            CollectibleView(collectible: $0)
                .frame(width: unitSize, height: unitSize)
                .position(position(for: $0.location))
        }
    }
}
