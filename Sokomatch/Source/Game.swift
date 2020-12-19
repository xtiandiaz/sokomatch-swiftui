//
//  Game.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 22.2.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import Foundation

class Game: ObservableObject {
    
    var stage: Stage
    
    init() {
        stage = Stage()
    }
    
    func start() {
//        stage.start()
    }
    
    func reset() {
        stage.reset()
    }
    
    // MARK: Private
}
