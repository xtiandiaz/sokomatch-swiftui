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
    
    @ObservedObject var stage: Stage
    
    var body: some View {
        ZStack {
            
            GeometryReader {
                proxy in
                Color.clear
                    .onAppear {
                        stage.size = proxy.size
                    }
            }
            
            if stage.isReady, let board = stage.board {
                BoardView(board: board)
                    .transition(.slide)
                    .animation(.default)
            }
        }
    }
}

