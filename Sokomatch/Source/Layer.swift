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
    
    func affect(with token: Token, at location: Location)
    func remove(tokenAtLocation location: Location)
    
    func clear()
    
    func token(at location: Location) -> Token?
    
    func isAvailable(location: Location) -> Bool
}

class BoardLayer<T: Layerable>: ObservableObject, Layer {
    
    let id = UUID()
    
    var tokens: [T] {
        Array(tokenAtLocation.values)
    }
    
    subscript(location: Location) -> T? {
        tokenAtLocation[location]
    }
    
    subscript(token: T) -> Location? {
        locationForToken[token]
    }
    
    func place(token: T) {
        tokenAtLocation[token.location] = token
        locationForToken[token] = token.location
    }
    
    func place(token: T, at location: Location) {
        remove(tokenAtLocation: location)
        
        var token = token
        token.location = location
        
        locationForToken[token] = location
        tokenAtLocation[location] = token
    }
    
    func relocate(token: T, to destination: Location) {
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
        if let token = tokenAtLocation[location] {
            locationForToken[token] = nil
        }
        tokenAtLocation[location] = nil
    }
    
    func clear() {
        objectWillChange.send()
        locationForToken.removeAll()
        tokenAtLocation.removeAll()
    }
    
    func affect(with token: Token, at location: Location) {
        guard let target = self[location] else {
            return
        }
        
        if let result = target.affect(with: token) {
            place(token: result, at: location)
            onTokenChanged(from: target, to: result, at: location)
        } else {
            remove(token: target)
            onTokenChanged(from: target, to: nil, at: location)
        }
    }
    
    func onTokenChanged(from: T?, to: T?, at location: Location) { }
    
    func isAvailable(location: Location) -> Bool {
        tokenAtLocation[location] == nil
    }
    
    func isObstructive(location: Location, for token: Token?) -> Bool {
        tokenAtLocation[location] != nil
    }
    
    func token(at location: Location) -> Token? {
        self[location]
    }
    
    // MARK: Private
    
    private var locationForToken = [T: Location]()
    private var tokenAtLocation = [Location: T]()
}

protocol BoardLayerView: View {
    
    var unitSize: CGFloat { get }
    
    func position(for location: Location) -> CGPoint
    func offset(for location: Location) -> CGSize
}

extension BoardLayerView {
    
    func position(for location: Location) -> CGPoint {
        CGPoint(
            x: CGFloat(location.x) * unitSize,
            y: CGFloat(location.y) * unitSize
        )
    }
    
    func offset(for location: Location) -> CGSize {
        CGSize(
            width: CGFloat(location.x) * unitSize,
            height: CGFloat(location.y) * unitSize
        )
    }
}
