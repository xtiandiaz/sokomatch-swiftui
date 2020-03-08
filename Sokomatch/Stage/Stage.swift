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
        board = Board(cols: 6, rows: 8, tileSize: 64)
        tokens = [
            Water(location: Location.zero),
            Water(location: board.center),
            Water(location: Location(x: 0, y: board.rows - 1)),
            Fire(location: Location(x: board.cols - 1, y: 0)),
            Fire(location: Location(x: board.cols - 1, y: board.rows - 1))
        ]
    }
}
