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
    
    let unitSize: CGFloat
    
    var body: some View {
        if let board = stage.board {
            BoardView(board: board, unitSize: unitSize)
                .transition(AnyTransition.opacity.animation(.default))
        }
    }
}

struct StageView_Previews: PreviewProvider {
    static var previews: some View {
        StageView(stage: Stage(), unitSize: 30)
    }
}
