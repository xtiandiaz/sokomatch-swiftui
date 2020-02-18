//
//  Board.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 15.2.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import SwiftUI

struct BoardView<Content: View>: View {
    
    private let board: Board
    private let content: (CGFloat) -> Content
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.yellow)
            
            self.content(board.tileSize)
        }
        .frame(
            width: CGFloat(board.cols) * board.tileSize,
            height: CGFloat(board.rows) * board.tileSize)
    }
    
    init(board: Board, @ViewBuilder content: @escaping (CGFloat) -> Content) {
        self.board = board
        self.content = content
    }
}

struct Board_Previews: PreviewProvider {
    static var previews: some View {
        BoardView(board: Board.example) { tileSize in
            TokenView(token: Blob.example, size: tileSize, stepLength: tileSize)
            TokenView(token: Blob.example2, size: tileSize, stepLength: tileSize)
        }
    }
}
