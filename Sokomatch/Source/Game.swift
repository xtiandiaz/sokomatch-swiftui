//
//  Game.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 22.2.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import Combine
import CoreGraphics

enum GameEvent {
    
    case earnedScore(value: Int)
    case collectedCard(type: CardType, value: Int)
}

class Game: ObservableObject {
    
    @Published
    private(set) var stage: Stage
    @Published
    private(set) var score = 0
    
    init(inventory: Slot) {
        self.inventory = inventory
        
        stage = Stage(inventory: inventory)
        
        stage.onEvent.sink {
            [weak self] in
            self?.onEvent($0)
        }.store(in: &cancellables)
    }
    
    func reset() {
        stage.reset()
    }
    
    // MARK: Private
    
    private let inventory: Slot
    
    private var cancellables = Set<AnyCancellable>()
    
    private func onEvent(_ event: GameEvent) {
        switch event {
        case .earnedScore(let value):
            score += value
        case .collectedCard(let type, let value):
            inventory.push(card: Card(type: type, value: value))
        }
    }
}
