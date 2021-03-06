//
//  InteractionController.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 1.3.2021.
//  Copyright © 2021 Berilio. All rights reserved.
//

import Foundation

struct InteractionController {
    
    init(layers: [Layer]) {
        self.layers = layers
    }
    
    func canCollide(token: Token, at location: Location) -> Bool {
        layers.compactMap { $0.token(at: location) }.first { canCollide(token: token, with: $0 ) } != nil
    }
    
    func canCollide(token: Token, with other: Token) -> Bool {
        token.collisionMask.contains(other.category) || other.collisionMask.contains(token.category)
    }
    
    func canInteract(token: Token, at location: Location) -> Bool {
        layers.compactMap { $0.token(at: location) }.first { canInteract(token: token, with: $0) } != nil
    }
    
    func canInteract(token: Token, with other: Token) -> Bool {
        token.interactionMask.contains(other.category) || other.interactionMask.contains(token.category)
    }
    
    func canInteract(layer: Layer, at location: Location) -> Bool {
        guard let token = layer.token(at: location) else {
            return false
        }
        
        return canInteract(token: token, at: location)
    }
    
    func interact(at location: Location) {
        layers.filter { canInteract(layer: $0, at: location) }.forEach { interact(with: $0, at: location) }
    }
    
    func interact(with layer: Layer, at location: Location) {
        layers.forEach { interact(layer: layer, with: $0, at: location) }
    }
    
    func interact(layer: Layer, with other: Layer, at location: Location) {
        guard let a = layer.token(at: location), let b = other.token(at: location), a.id != b.id else {
            return
        }
        
        if canInteract(token: a, with: b) {
            layer.affect(with: b, at: location)
        }
        
        if canInteract(token: b, with: a) {
            other.affect(with: a, at: location)
        }
    }
    
    // MARK: Private
    
    private let layers: [Layer]
}
