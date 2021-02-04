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
    var board: Board?
    
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
    
    private var size: CGSize = .zero
    
    private var cancellables = Set<AnyCancellable>()
    
    private func advance() {
        board = board(withSize: size)
        board?.populate()
        
        board?.onEvent.sink {
            [weak self] in
            guard let self = self else {
                return
            }
            
            switch $0 {
            case .goal:
                self.advance()
            case .collectible(let type, let value):
                self.collect(type: type, value: value)
            }
        }.store(in: &cancellables)
    }
    
    private func collect(type: CollectibleType, value: Int) {
        switch type {
        case .coin:
            eventSubject.send(.earnedScore(value: value))
        }
    }
    
    private func board(withSize size: CGSize) -> Board {
        let length = {
            Array(stride(from: 3, through: 7, by: 2)).randomElement()!
        }
        return Board(cols: length(), rows: length(), width: size.width)
    }
}

extension Board {
    
    func populate() {
        place(token: Avatar(), at: center)
        place(token: Trigger(event: .goal), at: corners.randomElement()!)
        
        for _ in 0..<Int.random(in: 1...3) {
            if let location = randomLocation() {
                place(token: Collectible(subtype: .coin), at: location)
            }
        }
        
        for _ in 0..<Int.random(in: 0...2) {
            if let location = randomLocation() {
                place(token: Wall(), at: location)
            }
        }
    }
}

// MARK: - Templates

extension Stage {
    
    static let preview = Stage()
}
