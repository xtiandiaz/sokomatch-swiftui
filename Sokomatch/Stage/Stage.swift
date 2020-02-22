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
    
    init() {
        board = Board(cols: 7, rows: 7, tileSize: 55)
    }
}
