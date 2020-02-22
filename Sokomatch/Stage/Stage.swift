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
        board = Board(cols: 7, rows: 7, tileSize: 58)
        tokens = [
            Blob(location: Location.zero, style: .red),
            Blob(location: board.center, style: .blue),
            Blob(location: Location(x: 0, y: board.rows - 1), style: .blue),
            Blob(location: Location(x: board.cols - 1, y: 0), style: .blue),
            Blob(location: Location(x: board.cols - 1, y: board.rows - 1), style: .green)
        ]
    }
}
