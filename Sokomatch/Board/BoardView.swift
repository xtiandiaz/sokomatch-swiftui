//
//  Board.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 15.2.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import SwiftUI
import Combine

struct BoardView: View {
    
    @ObservedObject var viewModel: BoardViewModel
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.yellow)
                .zIndex(-1)
            
            ForEach(self.viewModel.tokenIds, id: \.self) { id in
                TokenView(
                    token: self.viewModel.token(fromId: id),
                    size: self.viewModel.tileSize,
                    stepLength: self.viewModel.tileSize)
            }
        }
        .frame(
            width: CGFloat(viewModel.board.cols) * viewModel.board.tileSize,
            height: CGFloat(viewModel.board.rows) * viewModel.board.tileSize)
    }
    
    init(viewModel: BoardViewModel) {
        self.viewModel = viewModel
    }
}

struct Board_Previews: PreviewProvider {
    static var previews: some View {
        BoardView(viewModel: BoardViewModel(board: Board.example))
    }
}
