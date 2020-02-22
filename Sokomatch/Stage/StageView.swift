//
//  StageView.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 22.2.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import SwiftUI

struct StageView: View {
    
    @ObservedObject var viewModel: StageViewModel
    
    var body: some View {
        BoardView(viewModel: viewModel.boardVM)
            .gesture(DragGesture(minimumDistance: self.viewModel.tileSize / 3)
                .onEnded { value in
                    let dir: Direction
                    let deltaX = value.translation.width
                    let deltaY = value.translation.height
                    if abs(deltaX) > abs(deltaY) {
                        dir = deltaX > 0 ? .right : .left
                    } else {
                        dir = deltaY > 0 ? .up : .down
                    }
                    
                    withAnimation(.linear(duration: BoardViewModel.transitionDuration)) {
                        self.viewModel.move(
                            tokenAtLocation: Location(
                                x: Int(value.startLocation.x / self.viewModel.tileSize),
                                y: Int(value.startLocation.y / self.viewModel.tileSize)),
                            toward: dir)
                    }
            })
    }
}

struct StageView_Previews: PreviewProvider {
    static var previews: some View {
        StageView(viewModel: StageViewModel(stage: Stage.example, boardVM: BoardViewModel(board: Board.example)))
    }
}
