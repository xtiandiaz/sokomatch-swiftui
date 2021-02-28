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
    
    @Inject
    private(set) var controlManager: ControlManager
    @Inject
    private(set) var inventory: Slot
    
    @Published
    private(set) var board: Board?
    
    var onEvent: AnyPublisher<GameEvent, Never> {
        eventSubject.eraseToAnyPublisher()
    }
    
    init() {
        controlManager.onSwipe.sink {
            [weak self] in
            self?.board?.move(toward: $0)
        }.store(in: &cancellables)
        
        controlManager.onDoubleTap.sink {
            [weak self] in
            self?.board?.command3()
        }.store(in: &cancellables)
        
        inventory.onExecuted.sink {
            [weak self] in
            self?.board?.execute(card: $0)
        }.store(in: &cancellables)
        
        advance()
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
        
        board?.onEvent.sink {
            [weak self] in
            self?.onBoardEvent($0)
        }.store(in: &cancellables)
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
                inventory.push(card: Card(type: type, value: value))
            }
        case .reachedGoal:
            advance()
        default:
            break
        }
    }
}
