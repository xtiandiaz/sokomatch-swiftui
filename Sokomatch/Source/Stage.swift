//
//  Stage.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 16.2.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import SwiftUI
import Emerald

class Stage: ObservableObject {
    
    let board: Board
    
    init() {
        let cols = 6
        let rows = 6
        
        board = Board(cols: cols, rows: rows, tileSize: 64)
        
        let types: [TokenType?] = [.water, nil, .fire, nil, .bomb, nil, .boulder]
        
        for y in 0..<rows {
            for x in 0..<cols {
                guard let randomType = types.randomElement()! else {
                    continue
                }
                board.place(token: randomType.create(withLocation: Location(x: x, y: y)))
            }
        }
    }
    
    func reset() {
//        board.reset()
    }
    
    // MARK: Private
}

// MARK: - Templates

extension Stage {
    
    static let preview = Stage()
}
