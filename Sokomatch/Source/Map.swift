//
//  Map.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 22.11.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import Foundation
import Emerald

struct PieceLocation<P: Piece>: Identifiable, Hashable {
    
    let piece: P
    let location: Location
    
    var id: UUID { piece.id }
}

protocol Map {
    
    associatedtype P: Piece
    
    var pieces: [P] { get }
    var pieceLocations: [PieceLocation<P>] { get }
    
    subscript(location: Location) -> P? { get }
    subscript(piece: P) -> Location? { get }
    
    func isOccupied(location: Location) -> Bool
    
    func remove(piece: P)
    func place(piece: P, at location: Location) -> P
    func relocate(piece: P, to destination: Location)
}

class LayerMap<P: Piece>: Map {
    
    var pieces: [P] {
        Array(pieceAtLocation.values)
    }
    
    var pieceLocations: [PieceLocation<P>] {
        locationForPiece.map { PieceLocation(piece: $0.key, location: $0.value) }
    }
    
    subscript(location: Location) -> P? {
        pieceAtLocation[location]
    }
    
    subscript(piece: P) -> Location? {
        locationForPiece[piece]
    }
    
    @discardableResult
    func place(piece: P, at location: Location) -> P {
        locationForPiece[piece] = location
        pieceAtLocation[location] = piece
        return piece
    }
    
    func relocate(piece: P, to destination: Location) {
        remove(piece: piece)
        place(piece: piece, at: destination)
    }
    
    func remove(piece: P) {
        if let location = locationForPiece[piece] {
            pieceAtLocation[location] = nil
        }
        locationForPiece[piece] = nil
    }
    
    func clear() {
        locationForPiece.removeAll()
        pieceAtLocation.removeAll()
    }
    
    func isOccupied(location: Location) -> Bool {
        pieceAtLocation[location] != nil
    }
    
    // MARK: Private
    
    private var locationForPiece = [P: Location]()
    private var pieceAtLocation = [Location: P]()
}
