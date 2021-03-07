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
            MapLayerView(layer: board.mapLayer, unitSize: unitSize)
                .zIndex(0)
            TriggerLayerView(layer: board.triggerLayer, unitSize: unitSize)
                .zIndex(1)
            MovableLayerView(layer: board.movableLayer, unitSize: unitSize)
                .zIndex(2)
            CollectibleLayerView(layer: board.collectibleLayer, unitSize: unitSize)
                .zIndex(3)
            DroppableLayerView(layer: board.droppableLayer, unitSize: unitSize)
                .zIndex(4)
        }
        .offset(offset())
        .aspectRatio(1, contentMode: .fit)
        .id(board.id)
    }
    
    // MARK: Private
    
    private var viewportWidth: CGFloat {
        CGFloat(GameView.viewportUWidth) * unitSize
    }
    
    private var viewportHeight: CGFloat {
        CGFloat(GameView.viewportUHeight) * unitSize
    }
    
    private var tileOffset: CGSize {
        CGSize(widthAndHeight: unitSize * 0.5)
    }
    
    private var size: CGSize {
        CGSize(width: CGFloat(board.cols) * unitSize, height: CGFloat(board.rows) * unitSize)
    }
    
    private func position() -> CGPoint {
        let offset = self.offset()
        return CGPoint(x: offset.width, y: offset.height)
    }
    
    private func offset() -> CGSize {
        var offset: CGSize = .zero
        
        if board.cols <= GameView.viewportUWidth {
            offset.width = CGFloat(GameView.viewportUWidth - board.cols) * unitSize / 2
        } else {
//            let page = (board.playerLocation.x + 1) / GameView.viewportUWidth
//            let bleed = min(0, board.cols - GameView.viewportUWidth * (page + 1))
//            offset.width = -CGFloat(page) * viewportWidth - CGFloat(bleed) * unitSize
        }
        
//        if board.rows <= GameView.viewportUHeight {
            offset.height = CGFloat(GameView.viewportUHeight - board.rows) * unitSize / 2
//        } else {
//            let page = (board.playerLocation.y + 1) / GameView.viewportUHeight
//            let bleed = min(0, board.rows - GameView.viewportUHeight * (page + 1))
//            offset.height = -CGFloat(page) * viewportHeight - CGFloat(bleed) * unitSize
//        }
        
        return tileOffset + offset
    }
}

struct Board_Previews: PreviewProvider {
    static var previews: some View {
        BoardView(board: Board(cols: 5, rows: 5), unitSize: 30)
    }
}
