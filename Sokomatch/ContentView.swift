//
//  ContentView.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 15.2.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject private var stage: Stage
    
    private let board: Board
    
    var body: some View {
        BoardView(board: board) { tileSize in
            ForEach(self.stage._ids, id:\.self) { id in
                TokenView(token: self.stage.token(fromId: id), size: tileSize, stepLength: tileSize)
            }
        }
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
                    self.stage.move(
                        tokenAtLocation: Location(
                            x: Int(value.startLocation.x / self.board.tileSize),
                            y: Int(value.startLocation.y / self.board.tileSize)),
                        toward: dir)
                }
        })
        .onAppear {
            self.stage.place(token: Blob(location: Location.zero, style: .red))
            self.stage.place(token: Blob(location: self.board.center, style: .blue))
            self.stage.place(token: Blob(location: Location(x: self.board.cols - 1, y: self.board.rows - 1), style: .green))
        }
    }
    
    init() {
        board = Board(cols: 7, rows: 7, tileSize: 55)
        stage = Stage(board: board)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
