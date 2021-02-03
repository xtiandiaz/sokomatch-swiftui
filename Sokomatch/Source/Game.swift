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
    var stage: Stage?
    
    @Published
    var score = 0
    
    func setup(size: CGSize) {
        stage = Stage()
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
    
    private var cancellables = Set<AnyCancellable>()
}
