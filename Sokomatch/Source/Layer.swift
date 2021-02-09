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

class BoardLayer<P: Piece>: ObservableObject, Layer, Map {
    
    let id = UUID()
    let locations: Set<Location>
    let unitSize: CGFloat
    
    required init(locations: Set<Location>, unitSize: CGFloat) {
        self.locations = locations
        self.unitSize = unitSize
    }
    
    var pieces: [P] {
        map.pieces
    }
    
    var pieceLocations: [PieceLocation<P>] {
        map.pieceLocations
    }
    
    subscript(token: P) -> Location? {
        map[token]
    }
    
    subscript(location: Location) -> P? {
        map[location]
    }
    
    func create(at location: Location) -> P {
        fatalError("Not implemented")
    }
    
    @discardableResult
    func place(piece: P, at location: Location) -> P {
        map.place(piece: piece, at: location)
    }
    
    func relocate(piece: P, to destination: Location) {
        objectWillChange.send()
        map.relocate(piece: piece, to: destination)
    }
    
    func remove(piece: P) {
        objectWillChange.send()
        map.remove(piece: piece)
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
        
        if let result = target.interact(with: source) as? P {
            place(piece: result, at: location)
        } else if let token = self[location] {
            remove(piece: token)
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
    
    func location(for token: P) -> Location? {
        map[token]
    }
    
    func position(for location: Location) -> CGPoint {
        CGPoint(
            x: CGFloat(location.x) * unitSize + unitSize / 2,
            y: CGFloat(location.y) * unitSize + unitSize / 2)
    }
    
    // MARK: Private
    
    private var map = LayerMap<P>()
}
