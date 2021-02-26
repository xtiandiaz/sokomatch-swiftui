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

class Board: ObservableObject {
    
    static let moveDuration: TimeInterval = 0.1
    static let maxMoveSteps = 100
    
    @Published
    private(set) var playerLocation: Location = .zero
    
    let id = UUID()
    let cols: Int
    let rows: Int
    
    let locations: Set<Location>
    let center: Location
    let corners: Set<Location>
    let edges: Set<Location>
    let safeArea: Set<Location>
    
    let avatarLayer: AvatarLayer
    let mapLayer: MapLayer
    let accessLayer: AccessLayer
    let shovableLayer: ShovableLayer
    let collectibleLayer: CollectibleLayer
    let triggerLayer: TriggerLayer
    let droppableLayer: DroppableLayer
    
    let layers: [Layer]
    
    init(cols: Int, rows: Int) {
        self.cols = cols
        self.rows = rows
        
        center = Location(x: cols / 2, y: rows / 2)
        
        corners = [
            Location(x: 0, y: 0, corners: .topLeft),
            Location(x: cols - 1, y: 0, corners: .topRight),
            Location(x: 0, y: rows - 1, corners: .bottomLeft),
            Location(x: cols - 1, y: rows - 1, corners: .bottomRight)
        ]
        
        var edges = Set<Location>()
        var safeArea = Set<Location>()
        var locations = Set<Location>()
        
        for y in 0..<rows {
            for x in 0..<cols {
                let location = Location(x: x, y: y)
                
                locations.insert(location)
                
                if x == 0 || x == cols - 1 || y == 0 || y == rows - 1 {
                    edges.insert(location)
                } else {
                    safeArea.insert(location)
                }
            }
        }
        
        self.locations = locations
        self.edges = edges.subtracting(corners)
        self.safeArea = safeArea
        
        avatarLayer = AvatarLayer()
        mapLayer = MapLayer()
        accessLayer = AccessLayer()
        collectibleLayer = CollectibleLayer()
        shovableLayer = ShovableLayer()
        triggerLayer = TriggerLayer()
        droppableLayer = DroppableLayer()
        
        layers = [mapLayer, accessLayer, collectibleLayer, shovableLayer, avatarLayer, triggerLayer, droppableLayer]
        
        collectibleLayer.onCollected.sink(receiveValue: onCollected(_:)).store(in: &cancellables)
        triggerLayer.onTriggered.sink(receiveValue: onEvent(_:)).store(in: &cancellables)
    }
    
    var onEvent: AnyPublisher<BoardEvent, Never> {
        eventSubject.eraseToAnyPublisher()
    }
    
    func populate() {
        avatar = avatarLayer.create(at: center)
        
        for location in edges.union(corners) {
            mapLayer.create(tile: .bound, at: location)
        }
        
        for location in safeArea {
            mapLayer.create(tile: .floor, at: location)
        }
        
        var key: Collectible?
        if let location = randomAvailableLocation(in: safeArea), Bool.random() {
            key = collectibleLayer.create(.key, at: location)
        }
        
        if let location = edges.randomElement(), let edge = edge(forLocation: location) {
            mapLayer.create(tile: .passageway(edge), at: location)
            triggerLayer.create(withEvent: .reachedGoal, at: location)
            
            let entrance = location.shifted(toward: edge.facingDirection)
            mapLayer.create(tile: .stickyFloor, at: entrance)
            
            if let key = key {
                accessLayer.create(withKey: key.id, at: location)
                triggerLayer.create(withKey: key.id, at: entrance)
            }
        }
        
        for _ in 0...diagonal/3 {
            if let location = randomAvailableLocation(in: safeArea) {
                collectibleLayer.create(.coin(value: 1), at: location)
            }
        }
        
        for _ in 1...diagonal/4 {
            if let location = randomAvailableLocation(in: safeArea) {
                shovableLayer.create(.block, at: location)
            }
            if let location = randomAvailableLocation(in: safeArea) {
                mapLayer.create(tile: .pit, at: location)
            }
        }
        
        if diagonal > 7, let location = randomAvailableLocation(in: safeArea) {
            collectibleLayer.create(.card(type: .random(), value: 1), at: location)
        }
    }
    
    func move(toward direction: Direction) {
        guard let avatar = avatar else {
            return
        }
        
        move(
            layer: avatarLayer,
            at: avatar.location,
            toward: direction,
            maxSteps: avatar.isHovering ? 1 : Self.maxMoveSteps
        )
        
        playerLocation = avatar.location
    }
    
    func execute(card: Card) {
        switch card.type {
        case .attraction: command2()
        case .hover: command1()
        }
    }
    
    func command1() {
        withAnimation {
            avatar?.isHovering.toggle()
        }
        
        if let avatar = avatar, !avatar.isHovering {
            interact(with: avatarLayer, at: avatar.location)
        }
    }
    
    func command2() {
        guard let center = avatar?.location else {
            return
        }
        
        for dir in Direction.allCases {
            guard let token = first(in: shovableLayer, from: center, toward: dir) else {
                continue
            }
            
            move(layer: shovableLayer, at: token.location, toward: dir.opposite)
        }
    }
    
    func command3() {
        guard let location = avatar?.location else {
            return
        }
        
        let bomb = droppableLayer.place(Bomb(location: location))
        bomb.detonate(after: 2.0)
    }
    
    static func create() -> Board {
        let length = { (5...9).randomElement()! }
        return Board(cols: length(), rows: length())
    }
    
    static func moveAnimation() -> Animation {
        .linear(duration: moveDuration)
    }
    
    // MARK: Private
    
    private let eventSubject = PassthroughSubject<BoardEvent, Never>()
    
    private weak var avatar: Avatar?
    
    private var cancellables = Set<AnyCancellable>()
    
    private func move<T: Layerable>(
        layer: BoardLayer<T>,
        at location: Location,
        toward direction: Direction,
        maxSteps: Int = Board.maxMoveSteps
    ) {
        guard let token = layer[location] else {
            return
        }
        
        let destination = move(token: token, from: location, toward: direction, maxSteps: maxSteps)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Self.moveDuration) {
            if self.canInteract(with: token, at: destination) {
                self.interact(with: layer, at: destination)
            }
            
            if self.shovableLayer[destination.shifted(toward: direction)] != nil {
                self.move(layer: self.shovableLayer, at: destination.shifted(toward: direction), toward: direction)
            }
        }
    }
    
    @discardableResult
    private func move(
        token: Token,
        from origin: Location,
        toward direction: Direction,
        maxSteps: Int = Board.maxMoveSteps
    ) -> Location {
        let nextLocation = origin.shifted(toward: direction)
        
        if
            !isValid(location: nextLocation) ||
            isObstructive(location: nextLocation, for: token) ||
            maxSteps <= 0
        {
            withAnimation(Self.moveAnimation()) {
                relocate(token: token, to: origin)
            }
            return origin
        }
        
        if canInteract(with: token, at: nextLocation) {
            withAnimation(Self.moveAnimation()) {
                relocate(token: token, to: nextLocation)
            }
            return nextLocation
        }
        
        return move(token: token, from: nextLocation, toward: direction, maxSteps: maxSteps - 1)
    }
    
    private func relocate(token: Token, to location: Location) {
        switch token {
        case let avatar as Avatar:
            avatarLayer.relocate(token: avatar, to: location)
        case let shovable as Shovable:
            shovableLayer.relocate(token: shovable, to: location)
        default:
            break
        }
    }
    
    private func remove(token: Token) {
        switch token {
        case let avatar as Avatar:
            avatarLayer.remove(token: avatar)
        case let shovable as Shovable:
            shovableLayer.remove(token: shovable)
        default:
            break
        }
    }
    
    private func onCollected(_ collectible: Collectible) {
        switch collectible.type {
        case .key: avatar?.addKey(collectible.id)
        default: break
        }
        
        eventSubject.send(.collected(collectible))
    }
    
    private func onEvent(_ event: BoardEvent) {
        switch event {
        case .unlocked(let key):
            accessLayer.unlock(withKey: key)
        default:
            break
        }
        
        eventSubject.send(event)
    }
    
    private func canInteract(with token: Token, at location: Location) -> Bool {
        layers.first { $0.canInteract(with: token, at: location) } != nil
    }
    
    private func interact<T>(with layer: BoardLayer<T>, at location: Location) {
        guard let source = layer[location] else {
            return
        }
        
        layers
            .filter { $0.canInteract(with: layer, at: location) }
            .forEach {
                if let target = $0.token(at: location) {
                    layer.affect(with: target, at: location)
                }
                $0.affect(with: source, at: location)
            }
    }
    
    func clear() {
        layers.forEach { $0.clear() }
    }
    
    private func isValid(location: Location) -> Bool {
        locations.contains(location)
    }
    
    private func isAvailable(location: Location) -> Bool {
        layers.first { !$0.isAvailable(location: location) } == nil
    }
    
    private func isObstructive(location: Location, for token: Token?) -> Bool {
        layers.first { $0.isObstructive(location: location, for: token) } != nil
    }
    
    private func first<T: Layerable>(
        in layer: BoardLayer<T>,
        from origin: Location,
        toward direction: Direction
    ) -> T? {
        let nextLocation = origin.shifted(toward: direction)
        
        guard isValid(location: nextLocation) else {
            return nil
        }
        
        if let token = layer[nextLocation] {
            return token
        }
        
        return first(in: layer, from: nextLocation, toward: direction)
    }
}

extension Board {
    
    private func randomAvailableLocation(in locations: Set<Location>) -> Location? {
        var location: Location?
        var attempts = 3
        repeat {
            if let loc = locations.randomElement(), isAvailable(location: loc) {
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
