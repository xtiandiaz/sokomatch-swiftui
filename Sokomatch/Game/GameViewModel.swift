//
//  GameViewModel.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 22.2.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import SwiftUI

class GameViewModel: ObservableObject {
    
    let stageVM: StageViewModel
    let boardVM: BoardViewModel
    
    private let game = Game()
    
    init() {
        boardVM = BoardViewModel(board: game.stage.board)
        stageVM = StageViewModel(stage: game.stage, boardVM: boardVM)
    }
    
    func start() {
        stageVM.start()
    }
    
    func restart() {
        stageVM.restart()
    }
}
