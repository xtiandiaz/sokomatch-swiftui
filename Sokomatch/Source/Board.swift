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

struct BoardLayout {
    
    let cols: Int
    let rows: Int
    let size: CGSize
    let tileSize: CGFloat
}

class Board: ObservableObject {
    
    let id: Int
    let cols: Int
    let rows: Int
    let center: Location
    
    @Published
    private(set) var layout: BoardLayout?
    
    var isReady: Bool {
        layout != nil
    }
    
    var onReady: AnyPublisher<Board, Never> {
        $layout.compactMap { $0 }.first().map { _ in self }.eraseToAnyPublisher()
    }
    
    init(id: Int, cols: Int, rows: Int) {
        self.id = id
        self.cols = cols
        self.rows = rows
        
        center = Location(x: cols / 2, y: rows / 2)
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
    
    func layOut(size: CGSize) {
        layout = BoardLayout(
            cols: cols,
            rows: rows,
            size: size,
            tileSize: size.width / CGFloat(cols))
    }
    
    func place(token: Token) {
        guard isValid(location: token.location) else {
            return
        }
        
        tokens[token.id] = token
        tokenLocations[token.location] = token
    }
    
    func clear() {
        tokens.removeAll()
        tokenLocations.removeAll()
    }
    
    // MARK: Private
    
    @Published private var tokens = [UUID: Token]()
    @Published private var tokenLocations = [Location: Token]()
}

// MARK: - Navigation

extension Board {
    
    func move(tokenAtLocation origin: Location, toward direction: Direction, ripple: Int = 0) {
        guard
            isValid(location: origin),
            let token = token(at: origin),
            token is Movable
        else {
            return
        }
        
        move(token: token, from: origin, toward: direction, ripple: ripple)
    }
    
    // MARK: Private
    
    @discardableResult
    private func move(token: Token, from origin: Location, toward direction: Direction, ripple: Int = 0) -> Location {
        let nextLocation = origin.shifted(toward: direction)
        
        guard isValid(location: nextLocation) else {
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
                    self?.remove(token: token)
                    self?.remove(token: other)
                    
                    if result.value > 0 {
                        self?.place(token: result, at: nextLocation)
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
    
    func place(token: Token, at location: Location) {
        guard isValid(location: location) else {
            return
        }
        var token = token
        token.location = location
        tokens[token.id] = token
        tokenLocations[location] = token
    }
    
    private func isValid(location: Location) -> Bool {
        location.x >= 0 && location.x < cols && location.y >= 0 && location.y < rows
    }
    
    private func isAvailable(location: Location) -> Bool {
        token(at: location) == nil
    }
}

// MARK: - Layout

extension Board {
    
    var tileSize: CGFloat {
        layout?.tileSize ?? 0
    }
    
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
                    board.layOut(size: proxy.size)
                }
                return Color.clear
            }
        }
    }
}

// MARK: - Templates

extension Board {
    
    static let preview = Board(id: 0, cols: 6, rows: 6)
}
