//
//  Stage.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 16.2.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import SwiftUI

struct Stage {
    
    static let example = Stage()
    
    let board: Board
    let tokens: [Token]
    
    init() {
        let cols = 6
        let rows = 6
        
        board = Board(cols: cols, rows: rows, tileSize: 64)
        
        let types: [TokenType?] = [.water, nil, .fire, nil, .bomb, nil, .boulder]
        var tokens = [Token]()
        
        for y in 0..<rows {
            for x in 0..<cols {
                guard let randomType = types.randomElement()! else {
                    continue
                }
                tokens.append(randomType.create(withLocation: Location(x: x, y: y)))
            }
        }
        
        self.tokens = tokens
    }
}
