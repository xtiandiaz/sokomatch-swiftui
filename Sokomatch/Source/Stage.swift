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
    
    init(inventory: Slot) {
        inventory.onExecuted.sink { self.board?.execute(card: $0) }.store(in: &cancellables)
        
        advance()
    }
    
    var onEvent: AnyPublisher<GameEvent, Never> {
        eventSubject.eraseToAnyPublisher()
    }
    
    func reset() {
        board?.clear()
        board?.populate()
    }
    
    // MARK: Private
    
    private let eventSubject = PassthroughSubject<GameEvent, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    private func advance() {
        board = Board.create()
        board?.populate()
        
        board?.onEvent.sink(receiveValue: onBoardEvent(_:)).store(in: &cancellables)
    }
    
    private func onBoardEvent(_ event: BoardEvent) {
        switch event {
        case .collected(let collectible):
            switch collectible.type {
            case .coin(let value):
                eventSubject.send(.earnedScore(value: value))
            case .key:
                break
            case .card(let type, let value):
                eventSubject.send(.collectedCard(type: type, value: value))
            }
        case .reachedGoal:
            advance()
        default:
            break
        }
    }
}
