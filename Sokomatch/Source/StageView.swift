//
//  StageView.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 22.2.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import SwiftUI
import Emerald

struct StageView: View {
    
    @ObservedObject
    var stage: Stage
    
    var body: some View {
        ZStack {
            Rectangle().fill(Color.black)
                .aspectRatio(1, contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
            
            if let board = stage.board {
                BoardView(board: board)
                    .transition(AnyTransition.opacity.animation(.default))
            }
        }
        .gesture(DragGesture(minimumDistance: 20).onEnded {
            let dir: Direction
            let deltaX = $0.translation.width
            let deltaY = $0.translation.height

            if abs(deltaX) > abs(deltaY) {
                dir = deltaX > 0 ? .right : .left
            } else {
                dir = deltaY > 0 ? .up : .down
            }

            withAnimation(Board.moveAnimation()) {
                stage.board?.move(toward: dir)
            }
        })
    }
}

struct StageView_Previews: PreviewProvider {
    static var previews: some View {
        StageView(stage: Stage(inventory: Inventory()))
    }
}
