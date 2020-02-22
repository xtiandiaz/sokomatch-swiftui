//
//  StageViewModel.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 22.2.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import SwiftUI

class StageViewModel: ObservableObject {
    
    let boardVM: BoardViewModel
    let tileSize: CGFloat
    
    private let stage: Stage
    
    init(stage: Stage, boardVM: BoardViewModel) {
        self.stage = stage
        self.boardVM = boardVM
        
        tileSize = stage.board.tileSize
    }
    
    func start() {
        placeTokens()
    }
    
    func restart() {
        boardVM.reset()
        start()
    }
    
    func move(tokenAtLocation location: Location, toward direction: Direction) {
        boardVM.move(tokenAtLocation: location, toward: direction)
    }
    
    private func placeTokens() {
        stage.tokens.forEach { boardVM.place(token: $0) }
    }
}
