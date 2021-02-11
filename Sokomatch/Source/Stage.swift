//
//  Stage.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 16.2.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import SwiftUI
import Combine
import Emerald

enum StageEvent {
    case goal
    case collectible(type: CollectibleType, value: Int)
}

class Stage: ObservableObject {
    
    @Published
    private(set) var board: Board?
    
    init(inventory: Inventory) {
        self.inventory = inventory
    }
    
    var onEvent: AnyPublisher<GameEvent, Never> {
        eventSubject.eraseToAnyPublisher()
    }
    
    func setup(size: CGSize) {
        self.size = size
        
        advance()
    }
    
    func reset() {
        board?.clear()
        board?.populate()
    }
    
    // MARK: Private
    
    private let eventSubject = PassthroughSubject<GameEvent, Never>()
    
    private let inventory: Inventory
    
    private var size: CGSize = .zero
    
    private var cancellables = Set<AnyCancellable>()
    
    private func advance() {
        board = Board.create(withSize: size)
        board?.populate()
        
        board?.onEvent.sink(receiveValue: onBoardEvent(_:)).store(in: &cancellables)
    }
    
    private func onBoardEvent(_ event: BoardEvent) {
        switch event {
        case .collected(let collectible):
            switch collectible.subtype {
            case .coin: eventSubject.send(.earnedScore(value: collectible.value))
            case .key: break//inventory.add(collectible)
            }
        case .reachedGoal:
            advance()
        default:
            break
        }
    }
}
