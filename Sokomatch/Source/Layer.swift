//
//  Layer.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 6.2.2021.
//  Copyright © 2021 Berilio. All rights reserved.
//

import SwiftUI
import Emerald

protocol Layer: Codable {
    
    var id: UUID { get }
    
    func affect(with token: Token, at location: Location)
    func remove(tokenAtLocation location: Location)
    
    func clear()
    
    func token(at location: Location) -> Token?
    
    func isAvailable(location: Location) -> Bool
}

class BoardLayer<T: Layerable>: ObservableObject, Layer {
    
    let id: UUID
    
    var tokens: [T] {
        Array(tokenAtLocation.values)
    }
    
    init() {
        id = UUID()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(UUID.self, forKey: .id)
        
        if let tokens = try container.decodeIfPresent([T].self, forKey: .tokens) {
            for token in tokens {
                place(token: token)
            }
        }
    }
    
    subscript(location: Location) -> T? {
        tokenAtLocation[location]
    }
    
    subscript(token: T) -> Location? {
        locationForToken[token]
    }
    
    func place(token: T) {
        objectWillChange.send()
        
        tokenAtLocation[token.location] = token
        locationForToken[token] = token.location
    }
    
    func place(token: T, at location: Location) {
        remove(tokenAtLocation: location)
        
        locationForToken[token] = location
        tokenAtLocation[location] = token
    }
    
    func relocate(token: T, to destination: Location) {
        guard
            let current = self[token.location],
            current.id == token.id,
            current.location != destination
        else {
            return
        }
            
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
        
        let result = target.affect(with: token)
        
        if let result = result, result != target {
            place(token: result, at: location)
            onTokenChanged(from: target, to: result, at: location)
        } else if result == nil {
            remove(token: target)
            onTokenChanged(from: target, to: nil, at: location)
        }
    }
    
    func onTokenChanged(from: T, to: T?, at location: Location) { }
    
    func isAvailable(location: Location) -> Bool {
        tokenAtLocation[location] == nil
    }
    
    func token(at location: Location) -> Token? {
        self[location]
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(tokens, forKey: .tokens)
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

// MARK: - Codable

extension BoardLayer: Codable {
    
    enum CodingKeys: CodingKey {
        case id, tokens
    }
}
