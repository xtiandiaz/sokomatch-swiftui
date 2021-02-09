//
//  Map.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 22.11.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import Foundation
import Emerald

protocol Map {
    
    associatedtype T: Token & Hashable
    
    var tokens: [T] { get }
    var tokenLocations: [TokenLocation<T>] { get }
    
    subscript(location: Location) -> T? { get }
    subscript(token: T) -> Location? { get }
    
    func isOccupied(location: Location) -> Bool
    
    func remove(token: T)
    func place(token: T, at location: Location) -> T
    func relocate(token: T, to destination: Location)
}

struct TokenLocation<T: Token & Hashable>: Identifiable, Hashable {
    
    let token: T
    let location: Location
    
    var id: UUID { token.id }
}

class TokenMap<T: Token & Hashable>: Map {
    
    var tokens: [T] {
        Array(tokenAtLocation.values)
    }
    
    var tokenLocations: [TokenLocation<T>] {
        locationForToken.map { TokenLocation(token: $0.key, location: $0.value) }
    }
    
    subscript(location: Location) -> T? {
        tokenAtLocation[location]
    }
    
    subscript(token: T) -> Location? {
        locationForToken[token]
    }
    
    @discardableResult
    func place(token: T, at location: Location) -> T {
        locationForToken[token] = location
        tokenAtLocation[location] = token
        return token
    }
    
    func relocate(token: T, to destination: Location) {
        remove(token: token)
        place(token: token, at: destination)
    }
    
    func remove(token: T) {
        if let location = locationForToken[token] {
            tokenAtLocation[location] = nil
        }
        locationForToken[token] = nil
    }
    
    func clear() {
        locationForToken.removeAll()
        tokenAtLocation.removeAll()
    }
    
    func isOccupied(location: Location) -> Bool {
        tokenAtLocation[location] != nil
    }
    
    // MARK: Private
    
    private var locationForToken = [T: Location]()
    private var tokenAtLocation = [Location: T]()
}
