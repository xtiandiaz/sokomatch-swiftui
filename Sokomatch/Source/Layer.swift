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
    var unitSize: CGFloat { get }
    
    func canInteract(with source: Interactable, at location: Location) -> Bool
    func interact(with source: Interactable, at location: Location)
    func clear()
    
    func isOccupied(location: Location) -> Bool
    func isValid(location: Location) -> Bool
}

class BoardLayer<T: Token & Hashable & Identifiable>: ObservableObject, Layer, Map {
    
    let id = UUID()
    let locations: Set<Location>
    let unitSize: CGFloat
    
    required init(locations: Set<Location>, unitSize: CGFloat) {
        self.locations = locations
        self.unitSize = unitSize
    }
    
    var tokens: [T] {
        map.tokens
    }
    
    var tokenLocations: [TokenLocation<T>] {
        map.tokenLocations
    }
    
    subscript(token: T) -> Location? {
        map[token]
    }
    
    subscript(location: Location) -> T? {
        map[location]
    }
    
    func create(at location: Location) -> T {
        fatalError("Not implemented")
    }
    
    @discardableResult
    func place(token: T, at location: Location) -> T {
        map.place(token: token, at: location)
    }
    
    func relocate(token: T, to destination: Location) {
        objectWillChange.send()
        map.relocate(token: token, to: destination)
    }
    
    func remove(token: T) {
        objectWillChange.send()
        map.remove(token: token)
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
    
    func clear() {
        objectWillChange.send()
        map.clear()
    }
    
    func isOccupied(location: Location) -> Bool {
        map.isOccupied(location: location)
    }
    
    func isValid(location: Location) -> Bool {
        locations.contains(location)
    }
    
    func location(for token: T) -> Location? {
        map[token]
    }
    
    func position(for location: Location) -> CGPoint {
        CGPoint(
            x: CGFloat(location.x) * unitSize + unitSize / 2,
            y: CGFloat(location.y) * unitSize + unitSize / 2)
    }
    
    // MARK: Private
    
    private var map = TokenMap<T>()
}
