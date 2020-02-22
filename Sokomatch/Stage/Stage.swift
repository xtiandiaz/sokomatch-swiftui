//
//  Stage.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 16.2.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import SwiftUI

class Stage {
    
    let board: Board
    
    private(set) lazy var tokens = {[
        Blob(location: Location.zero, style: .red),
        Blob(location: board.center, style: .blue),
        Blob(location: Location(x: board.cols - 1, y: board.rows - 1), style: .green)
    ]}()
    
    init() {
        board = Board(cols: 7, rows: 7, tileSize: 55)
    }
}
