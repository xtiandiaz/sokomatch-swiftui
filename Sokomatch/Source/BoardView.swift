//
//  BoardView.swift
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
    
    let unitSize: CGFloat
    
    var body: some View {
        ZStack {
            Group {
                MapLayerView(layer: board.mapLayer, unitSize: unitSize)
                AccessLayerView(layer: board.accessLayer, unitSize: unitSize)
                CollectibleLayerView(layer: board.collectibleLayer, unitSize: unitSize)
                AvatarLayerView(layer: board.avatarLayer, unitSize: unitSize)
            }
            .offset(offset())
        }
        .id(board.id)
    }
    
    // MARK: Private
    
    private var tileOffset: CGSize {
        CGSize(widthAndHeight: unitSize * 0.5)
    }
    
    private var size: CGSize {
        CGSize(width: CGFloat(board.cols) * unitSize, height: CGFloat(board.rows) * unitSize)
    }
    
    private func offset() -> CGSize {
        tileOffset + CGSize(
            width: CGFloat(GameView.viewportUWidth - board.cols) * 0.5,
            height: CGFloat(GameView.viewportUWidth - board.rows) * 0.5
        ) * unitSize
        
//        CGSize(
//            width: (-CGFloat(board.playerLocation.x) + 4.5) * unitSize,
//            height: (-CGFloat(board.playerLocation.y) + 4.5) * unitSize
//        )
    }
}

struct Board_Previews: PreviewProvider {
    static var previews: some View {
        BoardView(board: Board(cols: 5, rows: 5), unitSize: 30)
    }
}
