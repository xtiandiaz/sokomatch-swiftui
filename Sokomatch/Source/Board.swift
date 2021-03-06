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

class Board: ObservableObject, Configurable {
    
    static let moveDuration: TimeInterval = 0.1
    static let maxMoveSteps = 100
    
    let id: UUID
    let cols: Int
    let rows: Int
    
    let mapLayer: MapLayer
    let movableLayer: MovableLayer
    let collectibleLayer: CollectibleLayer
    let triggerLayer: TriggerLayer
    let droppableLayer: DroppableLayer

    private(set) lazy var layers: [Layer] = [
        mapLayer, triggerLayer, collectibleLayer, movableLayer, droppableLayer
    ]
    
    var onEvent: AnyPublisher<BoardEvent, Never> {
        eventSubject.eraseToAnyPublisher()
    }
    
    init(cols: Int, rows: Int) {
        self.cols = cols
        self.rows = rows
        
        id = UUID()
        
        mapLayer = MapLayer()
        triggerLayer = TriggerLayer()
        collectibleLayer = CollectibleLayer()
        movableLayer = MovableLayer()
        droppableLayer = DroppableLayer()
        
        populate()
        subscribeToPublishers()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(UUID.self, forKey: .id)
        cols = try container.decode(Int.self, forKey: .cols)
        rows = try container.decode(Int.self, forKey: .rows)
        
        mapLayer = try container.decode(MapLayer.self, forKey: .mapLayer)
        triggerLayer = try container.decode(TriggerLayer.self, forKey: .triggerLayer)
        collectibleLayer = try container.decode(CollectibleLayer.self, forKey: .collectibleLayer)
        movableLayer = try container.decode(MovableLayer.self, forKey: .movableLayer)
        droppableLayer = try container.decode(DroppableLayer.self, forKey: .droppableLayer)
        
        avatar = movableLayer.avatars.first
        
        subscribeToPublishers()
    }
    
    func move(toward direction: Direction) {
        guard let avatar = avatar else {
            return
        }
        
        move(at: avatar.location, toward: direction)
    }
    
    func execute(card: Card) {
        guard let avatar = avatar else {
            return
        }
        
        switch card.type {
        case .ability(let ability):
            switch ability {
            case .magnesis:
                for dir in Direction.allCases {
                    guard let token = first(in: movableLayer, from: avatar.location, toward: dir) else {
                        continue
                    }
                    move(at: token.location, toward: dir.opposite)
                }
            }
        case .mode(let mode):
            withAnimation {
                avatar.mode = mode
            }
            
            switch mode {
            case .normal:
                interactionController.interact(with: movableLayer, at: avatar.location)
            default:
                break
            }
        }
    }
    
    func clear() {
        layers.forEach { $0.clear() }
    }
    
    func command3() {
        guard let location = avatar?.location else {
            return
        }
        
        droppableLayer.place(Bomb(location: location)).configure {
            $0.detonate(after: 2.0)
        }
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
    
    private var locks = [UUID: Location]()
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var interactionController = InteractionController(layers: layers)
    
    private lazy var locations: Set<Location> = {
        var locations = Set<Location>()
        
        for y in 0..<rows {
            for x in 0..<cols {
                locations.insert(Location(x: x, y: y))
            }
        }
        
        return locations
    }()
    
    private lazy var corners: Set<Location> = [
        Location(x: 0, y: 0, corners: .topLeft),
        Location(x: cols - 1, y: 0, corners: .topRight),
        Location(x: 0, y: rows - 1, corners: .bottomLeft),
        Location(x: cols - 1, y: rows - 1, corners: .bottomRight)
    ]
    
    private func move(at location: Location, toward direction: Direction, maxSteps: Int = Board.maxMoveSteps) {
        guard let token = movableLayer[location] else {
            return
        }
        
        let destination = move(token: token, from: location, toward: direction, maxSteps: maxSteps)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Self.moveDuration) {
            [weak self] in
            guard let self = self else {
                return
            }
            
            if self.interactionController.canInteract(layer: self.movableLayer, at: destination) {
                self.interactionController.interact(with: self.movableLayer, at: destination)
            }
            
            if
                let avatar = token as? Avatar,
                avatar.mode == .mighty,
                self.movableLayer[destination.shifted(toward: direction)] != nil
            {
                self.move(at: destination.shifted(toward: direction), toward: direction)
            }
        }
    }
    
    @discardableResult
    private func move(
        token: Movable,
        from origin: Location,
        toward direction: Direction,
        maxSteps: Int = Board.maxMoveSteps
    ) -> Location {
        let nextLocation = origin.shifted(toward: direction)
        
        if !isValid(location: nextLocation) ||
            interactionController.canCollide(token: token, at: nextLocation) ||
            maxSteps <= 0
        {
            withAnimation(Self.moveAnimation()) {
                movableLayer.relocate(token: token, to: origin)
            }
            return origin
        }
        
        if interactionController.canInteract(token: token, at: nextLocation) {
            withAnimation(Self.moveAnimation()) {
                movableLayer.relocate(token: token, to: nextLocation)
            }
            return nextLocation
        }
        
        return move(token: token, from: nextLocation, toward: direction, maxSteps: maxSteps - 1)
    }
    
    private func remove(in layers: [Layer], at locations: [Location]) {
        locations.forEach { remove(in: layers, at: $0) }
    }
    
    private func remove(in layers: [Layer], at location: Location) {
        layers.forEach { $0.remove(tokenAtLocation: location) }
    }
    
    private func lock(location: Location, with key: UUID) {
        mapLayer.create(.door(locked: true, edge: edge(forLocation: location)), at: location)
        locks[key] = location
    }
    
    private func unlock(with key: UUID) {
        if let location = locks[key] {
            mapLayer.place(
                token: Tile(type: .door(locked: false, edge: edge(forLocation: location)), location: location)
            )
            locks[key] = nil
        }
    }
    
    private func isValid(location: Location) -> Bool {
        locations.contains(location)
    }
    
    private func isAvailable(location: Location) -> Bool {
        layers.first { !$0.isAvailable(location: location) } == nil
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

// MARK: - Events

extension Board {
    
    func subscribeToPublishers() {
        collectibleLayer.onCollected.sink {
            [weak self] in
            self?.onCollected($0)
        }.store(in: &cancellables)

        triggerLayer.onTriggered.sink {
            [weak self] in
            self?.onEvent($0)
        }.store(in: &cancellables)
        
        droppableLayer.onEvent.sink {
            [weak self] in
            self?.onEvent($0)
        }.store(in: &cancellables)
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
            unlock(with: key)
        case .explosion(let location):
            remove(in: [movableLayer], at: area(around: location, withRadius: 1))
        default:
            break
        }
        
        eventSubject.send(event)
    }
}

// MARK: - Utilities

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
    
    private func area(around center: Location, withRadius radius: Int) -> [Location] {
        guard radius > 0 else {
            return [center]
        }
        
        var locations = [Location]()
        
        for y in -radius...radius {
            for x in -radius...radius {
                let location = center.shifted(byX: x, y: y)
                
                if self.locations.contains(location) {
                    locations.append(location)
                }
            }
        }
        
        return locations
    }
}

extension Board {
    
    func populate() {
        let center = Location(x: cols / 2, y: rows / 2)
        var edges = Set<Location>()
        var safeArea = Set<Location>()
        
        for l in locations {
            if l.x == 0 || l.x == cols - 1 || l.y == 0 || l.y == rows - 1 {
                edges.insert(l)
            } else {
                safeArea.insert(l)
            }
        }
        
        edges = edges.subtracting(corners)
        
        avatar = movableLayer.createAvatar(at: center)
        
        for location in edges.union(corners) {
            mapLayer.create(.bound, at: location)
        }
        
        for location in safeArea {
            mapLayer.create(.floor, at: location)
        }
        
        var key: Collectible?
        if let location = randomAvailableLocation(in: safeArea), Bool.random() {
            key = collectibleLayer.create(.key, at: location)
        }
        
        if let location = edges.randomElement(), let edge = edge(forLocation: location) {
            mapLayer.create(.passageway(edge), at: location)
            triggerLayer.create(withEvent: .reachedGoal, at: location)
            
            let entrance = location.shifted(toward: edge.facingDirection)
            mapLayer.create(.stickyFloor, at: entrance)
            
            if let key = key {
                lock(location: location, with: key.id)
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
                movableLayer.createBlock(at: location)
            }
            if let location = randomAvailableLocation(in: safeArea) {
                mapLayer.create(.pit, at: location)
            }
        }
        
        if diagonal > 7, let location = randomAvailableLocation(in: safeArea) {
            collectibleLayer.create(.card(type: .random(), value: 1), at: location)
        }
    }
}

// MARK: - Codable

extension Board: Codable {
    
    enum CodingKeys: String, CodingKey {
        case id, cols, rows
        case mapLayer, triggerLayer, collectibleLayer, movableLayer, droppableLayer
    }
    
}
