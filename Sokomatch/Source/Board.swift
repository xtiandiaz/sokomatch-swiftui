//
//  Board.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 16.2.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import SwiftUI
import CoreGraphics
import Emerald
import Combine

enum Edge {
    case top, left, bottom, right
}

enum BoardEvent {
    case collected(Collectible)
}

class Board: ObservableObject {
    
    static let minCols = 5
    static let maxCols = 9
    static let moveDuration: TimeInterval = 0.1
    
    let id = UUID()
    let cols: Int
    let rows: Int
    let unitSize: CGFloat
    
    let center: Location
    let corners: Set<Location>
    let edges: Set<Location>
    let safeArea: Set<Location>
    
    let layers: [Layer]
    var terrainLayer: TerrainLayer
    var avatarLayer: AvatarLayer
    var collectibleLayer: CollectibleLayer
    
    var onEvent: AnyPublisher<BoardEvent, Never> {
        eventSubject.eraseToAnyPublisher()
    }
    
    init(cols: Int, rows: Int, width: CGFloat) {
        self.cols = cols
        self.rows = rows
        
        unitSize = width / CGFloat(Self.maxCols)
        
        center = Location(x: cols / 2, y: rows / 2)
        
        corners = [
            Location(x: 0, y: 0),
            Location(x: cols - 1, y: 0),
            Location(x: 0, y: rows - 1),
            Location(x: cols - 1, y: rows - 1)
        ]
        
        var edges = Set<Location>()
        var safeArea = Set<Location>()
        
        for y in 0..<rows {
            for x in 0..<cols {
                let location = Location(x: x, y: y)
                
                if x == 0 || x == cols - 1 || y == 0 || y == rows - 1 {
                    edges.insert(location)
                } else {
                    safeArea.insert(location)
                }
            }
        }
        
        self.edges = edges.subtracting(corners)
        self.safeArea = safeArea
        
        avatarLayer = AvatarLayer(locations: safeArea, unitSize: unitSize)
        terrainLayer = TerrainLayer(locations: safeArea, unitSize: unitSize)
        collectibleLayer = CollectibleLayer(locations: safeArea, unitSize: unitSize)
        
        layers = [avatarLayer, terrainLayer, collectibleLayer]
        
        collectibleLayer.onCollected.sink(receiveValue: onCollected(_:)).store(in: &cancellables)
    }
    
    var width: CGFloat {
        CGFloat(cols) * unitSize
    }
    
    var height: CGFloat {
        CGFloat(rows) * unitSize
    }
    
    func populate() {
        avatar = avatarLayer.create(at: center)
        
//        for _ in 1...diagonal/4 {
//            if let location = randomAvailableLocation() {
//                avatarLayer.create(at: location)
//            }
//        }
        
//        let doorwayLocation = edges.randomElement()!
//        place(token: Doorway(edge: edge(forLocation: doorwayLocation)!), at: doorwayLocation)
        
        for _ in 1...diagonal/4 {
            if let location = randomAvailableLocation() {
                terrainLayer.create(at: location)
            }
        }
        
        for _ in 0..<Int.random(in: 1...3) {
            if let location = randomAvailableLocation() {
                collectibleLayer.create(.coin, at: location)
            }
        }
        
        if let location = randomAvailableLocation() {
            collectibleLayer.create(.key, at: location)
        }
    }
    
    func move(toward direction: Direction) {
        guard let avatar = avatar else {
            return
        }
        move(avatar: avatar, toward: direction)
    }
    
    func move(avatar: Avatar, toward direction: Direction) {
        guard let origin = avatarLayer.location(for: avatar) else {
            return
        }
        
        move(token: avatar, from: origin, toward: direction)
    }
    
    static func create(withSize size: CGSize) -> Board {
        let length = {
            (Self.minCols...Self.maxCols).randomElement()!
        }
        return Board(cols: length(), rows: length(), width: size.width)
    }
    
    static func moveAnimation() -> Animation {
        .linear(duration: moveDuration)
    }
    
    // MARK: Private
    
    private let eventSubject = PassthroughSubject<BoardEvent, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    private var avatar: Avatar?
    
    @discardableResult
    private func move<T: Token & Movable & Interactable>(
        token: T,
        from origin: Location,
        toward direction: Direction
    ) -> Location {
        let nextLocation = origin.shifted(toward: direction)

        if !isValid(location: nextLocation) {
            withAnimation(Self.moveAnimation()) {
                relocate(token: token, to: origin)
            }
            return origin
        }
        
        if canInteract(with: token, at: nextLocation) {
            
            withAnimation(Self.moveAnimation()) {
                relocate(token: token, to: nextLocation)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + Self.moveDuration) {
                [weak self] in
                self?.interact(with: token, at: nextLocation)
            }
            return nextLocation
            
        } else if isOccupied(location: nextLocation) {
            
            withAnimation(Self.moveAnimation()) {
                relocate(token: token, to: origin)
            }
            return origin
        }
        
        return move(token: token, from: nextLocation, toward: direction)
    }
    
    private func relocate(token: Token, to location: Location) {
        switch token {
        case let avatar as Avatar:
            avatarLayer.relocate(piece: avatar, to: location)
        default:
            break
        }
    }
    
    private func onCollected(_ collectible: Collectible) {
        eventSubject.send(.collected(collectible))
    }
}

extension Board: Layer {
    
    func canInteract(with source: Interactable, at location: Location) -> Bool {
        layers.first { $0.canInteract(with: source, at: location) } != nil
    }
    
    func interact(with source: Interactable, at location: Location) {
        layers.forEach { $0.interact(with: source, at: location) }
    }
    
    func clear() {
        layers.forEach { $0.clear() }
    }
    
    func isOccupied(location: Location) -> Bool {
        layers.first { $0.isOccupied(location: location) } != nil
    }
    
    func isValid(location: Location) -> Bool {
        layers.first { !$0.isValid(location: location) } == nil
    }
}

extension Board {
    
    private func randomAvailableLocation() -> Location? {
        var location: Location?
        var attempts = 3
        repeat {
            if
                let loc = safeArea.randomElement(),
                (layers.first { $0.isOccupied(location: loc) } == nil)
            {
                location = loc
                break
            }
            attempts -= 1
        } while attempts > 0
        
        return location
    }
    
    private func edge(forLocation location: Location) -> Edge? {
        guard !corners.contains(location) else {
            return nil
        }
        
        if location.x == 0 { return .left }
        if location.x >= cols - 1 { return .right}
        if location.y == 0 { return .top }
        if location.y >= rows - 1 { return .bottom }
        
        return nil
    }
    
    private var diagonal: Int {
        Int(sqrt(pow(Double(cols), 2) + pow(Double(rows), 2)))
    }
}
