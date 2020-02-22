//
//  StageView.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 22.2.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import SwiftUI

struct StageView: View {
    
    @ObservedObject private var vm: ViewModel
    
    var body: some View {
        BoardView(board: vm.board)
            .gesture(DragGesture(minimumDistance: vm.board.tileSize / 3)
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
                        self.vm.move(
                            tokenAtLocation: Location(
                                x: Int(value.startLocation.x / self.vm.board.tileSize),
                                y: Int(value.startLocation.y / self.vm.board.tileSize)),
                            toward: dir)
                    }
            })
            .onAppear {
                self.vm.placeTokens()
            }
    }
    
    init(stage: Stage) {
        vm = ViewModel(stage: stage)
    }
}

struct StageView_Previews: PreviewProvider {
    static var previews: some View {
        StageView(stage: Stage())
    }
}

extension StageView {
    
    class ViewModel: ObservableObject {
        
        let stage: Stage
        let board: Board
        
        init(stage: Stage) {
            self.stage = stage
            board = stage.board
        }
        
        func placeTokens() {
            stage.tokens.forEach { board.place(token: $0) }
        }
        
        func move(tokenAtLocation location: Location, toward direction: Direction) {
            board.move(tokenAtLocation: location, toward: direction)
        }
    }
}
