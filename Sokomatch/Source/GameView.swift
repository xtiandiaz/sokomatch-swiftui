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
    
    @ObservedObject var game: Game
    
    var body: some View {
        VStack {
            StageView(stage: game.stage)
            
//            Button("Restart") {
//                game.restart()
//            }
        }
        .onAppear {
            //game.start()
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(game: Game(stage: Stage.preview))
    }
}
