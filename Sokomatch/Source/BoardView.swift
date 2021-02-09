//
//  Board.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 15.2.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import SwiftUI
import Emerald

struct BoardView: View {
    
    @ObservedObject
    var board: Board
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Rectangle()
                .fill(Color.purple.opacity(0.25))
                .padding(board.unitSize)
                .zIndex(-1)
            
            TerrainLayerView(layer: board.terrainLayer)
            CollectibleLayerView(layer: board.collectibleLayer)
            AvatarLayerView(layer: board.avatarLayer)
        }
        .frame(width: board.width, height: board.height)
        .id(board.id)
    }
}

struct Board_Previews: PreviewProvider {
    static var previews: some View {
        BoardView(board: Board(cols: 5, rows: 5, width: 300))
    }
}
