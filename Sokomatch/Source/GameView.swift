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
        ZStack(alignment: .top) {
            VStack {
                Spacer()
                StageView(stage: game.stage)
                Spacer()
            }
            
            Button("Reset") {
                game.reset()
            }
        }
        .onAppear {
            game.start()
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(game: Game())
    }
}
