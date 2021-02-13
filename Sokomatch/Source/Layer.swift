//
//  Layer.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 6.2.2021.
//  Copyright © 2021 Berilio. All rights reserved.
//

import SwiftUI
import Emerald

protocol Layer {
    
    var id: UUID { get }
    
    func canInteract(with source: Interactable, at location: Location) -> Bool
    func interact(with source: Interactable, at location: Location)
    
    func clear()
    
    func isAvailable(location: Location) -> Bool
    func isObstructive(location: Location) -> Bool
}

struct BoardSpot<T: Token & Hashable>: Hashable & Identifiable {
    
    let token: T
    let location: Location
    
    var id: UUID { token.id }
}

class BoardLayer<T: Token & Hashable & Identifiable>: ObservableObject, Layer {
    
    let id = UUID()
    
    var tokens: [T] {
        Array(tokenAtLocation.values)
    }
    
    var spots: [BoardSpot<T>] {
        locationForToken.map { BoardSpot(token: $0.key, location: $0.value) }
    }
    
    subscript(location: Location) -> T? {
        tokenAtLocation[location]
    }
    
    subscript(piece: T) -> Location? {
        locationForToken[piece]
    }
    
    @discardableResult
    func place(token: T, at location: Location) -> T {
        remove(tokenAtLocation: location)
        locationForToken[token] = location
        tokenAtLocation[location] = token
        return token
    }
    
    func relocate(token: T, to destination: Location) {
        objectWillChange.send()
        remove(token: token)
        place(token: token, at: destination)
    }
    
    func remove(token: T) {
        objectWillChange.send()
        if let location = locationForToken[token] {
            tokenAtLocation[location] = nil
        }
        locationForToken[token] = nil
    }
    
    func remove(tokenAtLocation location: Location) {
        objectWillChange.send()
        if let piece = tokenAtLocation[location] {
            locationForToken[piece] = nil
        }
        tokenAtLocation[location] = nil
    }
    
    func clear() {
        objectWillChange.send()
        locationForToken.removeAll()
        tokenAtLocation.removeAll()
    }
    
    func canInteract(with source: Interactable, at location: Location) -> Bool {
        guard let target = self[location] as? Interactable else {
            return false
        }
        return target.canInteract(with: source)
    }
    
    func interact(with source: Interactable, at location: Location) {
        guard let target = self[location] as? Interactable else {
            return
        }
        
        if let result = target.interact(with: source) as? T {
            place(token: result, at: location)
        } else if let token = self[location] {
            remove(token: token)
        }
    }
    
    func isAvailable(location: Location) -> Bool {
        tokenAtLocation[location] == nil
    }
    
    func isObstructive(location: Location) -> Bool {
        tokenAtLocation[location] != nil
    }
    
    // MARK: Private
    
    private var locationForToken = [T: Location]()
    private var tokenAtLocation = [Location: T]()
}

protocol BoardLayerView: View {
    
    var unitSize: CGFloat { get }
    
    func position(for location: Location) -> CGPoint
}

extension BoardLayerView {
    
    func position(for location: Location) -> CGPoint {
        CGPoint(
            x: CGFloat(location.x) * unitSize,
            y: CGFloat(location.y) * unitSize
        )
    }
}
