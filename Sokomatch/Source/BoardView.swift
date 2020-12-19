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
    
    @ObservedObject var board: Board
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.init(red: 0.15, green: 0.15, blue: 0.15))
                .zIndex(-1)
            
            ForEach(board.tokenIds, id: \.self) { id in
                TokenView(
                    token: board.token(id: id),
                    size: board.tileSize,
                    stepLength: board.tileSize)
            }
        }
        .frame(width: board.width, height: board.height)
        .gesture(DragGesture(minimumDistance: board.tileSize / 3)
            .onEnded { value in
                let dir: Direction
                let deltaX = value.translation.width
                let deltaY = value.translation.height
                if abs(deltaX) > abs(deltaY) {
                    dir = deltaX > 0 ? .right : .left
                } else {
                    dir = deltaY > 0 ? .up : .down
                }

                withAnimation(.linear(duration: 0.1)) {
                    board.move(
                        tokenAtLocation: Location(
                            x: Int(value.startLocation.x / board.tileSize),
                            y: Int(value.startLocation.y / board.tileSize)),
                        toward: dir)
                }
        })
        .id(board.id)
    }
}

struct Board_Previews: PreviewProvider {
    static var previews: some View {
        BoardView(board: Board.preview)
    }
}
