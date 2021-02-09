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
}

class Game: ObservableObject {
    
    @Published
    private(set) var stage: Stage?
    @Published
    private(set) var score = 0
    
    init(inventory: Inventory) {
        self.inventory = inventory
    }
    
    func setup(size: CGSize) {
        stage = Stage(inventory: inventory)
        stage?.setup(size: size)
        
        stage?.onEvent.sink {
            [weak self] in
            guard let self = self else {
                return
            }
            
            switch $0 {
            case .earnedScore(let value):
                self.score += value
            }
        }.store(in: &cancellables)
    }
    
    func reset() {
        stage?.reset()
    }
    
    // MARK: Private
    
    private let inventory: Inventory
    
    private var cancellables = Set<AnyCancellable>()
}
