//
//  Board.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 16.2.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import SwiftUI

class Board: ObservableObject {
    
    static let example = Board(cols: 6, rows: 6, tileSize: 50)
    
    let cols: Int
    let rows: Int
    let tileSize: CGFloat
    
    init(cols: Int, rows: Int, tileSize: CGFloat) {
        self.cols = cols
        self.rows = rows
        self.tileSize = tileSize
    }
}
