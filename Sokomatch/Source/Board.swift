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

struct BoardLayout {
    
    let cols: Int
    let rows: Int
    let size: CGSize
    let tileSize: CGFloat
}

class Board: ObservableObject {
    
    static let minCols = 5
    static let maxCols = 9
    
    let id = UUID()
    let cols: Int
    let rows: Int
    let tileSize: CGFloat
    
    let center: Location
    let corners: Set<Location>
    let edges: Set<Location>
    let safeArea: Set<Location>
    
    var onEvent: AnyPublisher<StageEvent, Never> {
        eventSubject.eraseToAnyPublisher()
    }
    
    init(cols: Int, rows: Int, width: CGFloat) {
        self.cols = cols
        self.rows = rows
        
        tileSize = width / CGFloat(Self.maxCols)
        
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
    }
    
    var tokenIds: [UUID] {
        Array(tokens.keys)
    }
    
    func token(id: UUID) -> Token? {
        tokens[id]
    }
    
    func token(at location: Location) -> Token? {
        tokenLocations[location]
    }
    
    func place(token: Token, at location: Location) {
        guard isValid(location: location) else {
            return
        }
        var token = token
        token.location = location
        tokens[token.id] = token
        tokenLocations[location] = token
        
        switch token {
        case let avatar as Avatar:
            self.avatar = avatar
        default:
            break
        }
    }
    
    func move(toward direction: Direction) {
        guard let avatar = avatar else {
            return
        }
        
        move(tokenAtLocation: avatar.location, toward: direction)
    }
    
    func clear() {
        tokens.removeAll()
        tokenLocations.removeAll()
    }
    
    // MARK: Private
    
    private let eventSubject = PassthroughSubject<StageEvent, Never>()
    
    @Published
    private var tokens = [UUID: Token]()
    @Published
    private var tokenLocations = [Location: Token]()
    
    private var avatar: Avatar?
    
    private func move(tokenAtLocation origin: Location, toward direction: Direction, ripple: Int = 0) {
        guard
            isValid(location: origin),
            let token = token(at: origin),
            token is Movable
        else {
            return
        }
        
        move(token: token, from: origin, toward: direction, ripple: ripple)
    }
}

// MARK: - Utilities

extension Board {
    
    func randomLocation() -> Location? {
        var location: Location?
        var attempts = 3
        repeat {
            if let loc = safeArea.randomElement(), isAvailable(location: loc) {
                location = loc
                break
            }
            attempts -= 1
        } while attempts > 0
        
        return location
    }
    
    func isValid(moveLocation location: Location) -> Bool {
        isWithinSafeArea(location: location) || tokenLocations[location]?.type == .doorway
    }
    
    func isValid(location: Location) -> Bool {
        location.x >= 0 && location.x < cols && location.y >= 0 && location.y < rows
    }
    
    func isWithinSafeArea(location: Location) -> Bool {
        location.x >= 1 && location.x < cols - 1 && location.y >= 1 && location.y < rows - 1
    }
    
    func isAvailable(location: Location) -> Bool {
        token(at: location) == nil
    }
    
    func edge(forLocation location: Location) -> Edge? {
        guard !corners.contains(location) else {
            return nil
        }
        
        if location.x == 0 { return .left }
        if location .x >= cols - 1 { return .right}
        if location.y == 0 { return .top }
        if location.y >= rows - 1 { return .bottom }
        
        return nil
    }
    
    // MARK: Private
    
    @discardableResult
    private func move(token: Token, from origin: Location, toward direction: Direction, ripple: Int = 0) -> Location {
        let nextLocation = origin.shifted(toward: direction)
        
        guard isValid(moveLocation: nextLocation) else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1 * Double(ripple)) {
                [weak self] in
                withAnimation(.linear(duration: 0.1)) {
                    self?.move(token: token, to: origin)
                }
            }
            return origin
        }
        
        guard isAvailable(location: nextLocation) else {
            if
                let other = self.token(at: nextLocation),
                let interactable = token as? Interactable,
                let otherInteractable = other as? Interactable,
                let result = interactable.interact(with: otherInteractable)
            {
                place(token: token, at: nextLocation)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    [weak self] in
                    guard let self = self else {
                        return
                    }
                    
                    self.remove(token: token)
                    self.remove(token: other)
                    
                    if result.value > 0 {
                        self.place(token: result, at: nextLocation)
                        
                        switch otherInteractable {
                        case is Doorway:
                            self.eventSubject.send(.goal)
                        case let collectible as Collectible:
                            self.eventSubject.send(.collectible(type: collectible.subtype, value: collectible.value))
                        default:
                            break
                        }
                    }
                }
                
                return nextLocation
            } else {
                move(token: token, to: origin)
                
                if
                    let other = self.token(at: nextLocation),
                    other is Shovable
                {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        [weak self] in
                        withAnimation(.linear(duration: 0.1)) {
                            self?.move(tokenAtLocation: nextLocation, toward: direction, ripple: ripple + 1)
                        }
                    }
                }
                
                return origin
            }
        }
        
        return move(token: token, from: nextLocation, toward: direction)
    }
    
    private func move(token: Token, to location: Location) {
        guard tokens[token.id] != nil, isValid(location: location) else {
            return
        }
        remove(token: token)
        place(token: token, at: location)
    }
    
    private func remove(token: Token) {
        tokens[token.id] = nil
        tokenLocations[token.location] = nil
    }
}

// MARK: - Layout

extension Board {
    
    var width: CGFloat {
        CGFloat(cols) * tileSize
    }
    
    var height: CGFloat {
        CGFloat(rows) * tileSize
    }
}

extension View {
    
    func resolveLayout(forBoard board: Board) -> some View {
        return backgroundPreferenceValue(SizePreferenceKey.self) {
            pref in
            GeometryReader {
                proxy -> Color in
                DispatchQueue.main.async {
//                    board.layOut(size: proxy.size)
                }
                return Color.clear
            }
        }
    }
}

// MARK: - Templates

extension Board {
    
    static let preview = Board(cols: 6, rows: 6, width: 300)
}
