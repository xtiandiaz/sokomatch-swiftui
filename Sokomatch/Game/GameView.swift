//
//  GameView.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 22.2.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import SwiftUI
import Combine

struct GameView: View {
    
    @ObservedObject var viewModel: GameViewModel
    
    var body: some View {
        VStack {
            StageView(viewModel: viewModel.stageVM)
            
            Button("Restart") {
                self.viewModel.restart()
            }
        }
        .onAppear {
            self.viewModel.start()
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(viewModel: GameViewModel())
    }
}
