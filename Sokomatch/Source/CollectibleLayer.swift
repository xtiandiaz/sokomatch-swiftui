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
    func create(_ subtype: CollectibleType, at location: Location) -> Collectible {
        let collectible = Collectible(subtype: subtype)
        place(token: collectible, at: location)
        return collectible
    }
    
    override func interact(with source: Interactable, at location: Location) {
        let collectible = self[location]
        
        super.interact(with: source, at: location)
        
        if let collectible = collectible, self[location] == nil {
            collectibleSubject.send(collectible)
        }
    }
    
    // MARK: Private
    
    private let collectibleSubject = PassthroughSubject<Collectible, Never>()
}

struct CollectibleLayerView: View {
    
    @ObservedObject
    var layer: CollectibleLayer
    
    var body: some View {
        ForEach(layer.spots, id: \.self) {
            CollectibleView(collectible: $0.token)
                .position(layer.position(for: $0.location))
                .frame(width: layer.unitSize, height: layer.unitSize)
        }
    }
}
