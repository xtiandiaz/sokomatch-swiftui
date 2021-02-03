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
        ZStack(alignment: .center) {
            GeometryReader {
                proxy in
                Color.clear.onAppear {
                    game.setup(size: proxy.size)
                }
            }
            
            VStack {
                Text("\(game.score)")
                    .font(.title)
                
                Spacer()
                
                if let stage = game.stage {
                    StageView(stage: stage)
                }
                
                Spacer()
                
                Button("Reset") {
                    game.reset()
                }
            }
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(game: Game())
    }
}
