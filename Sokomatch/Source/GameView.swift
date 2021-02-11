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
    
    @EnvironmentObject
    var game: Game
    @EnvironmentObject
    var inventory: Inventory
    
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
                
//                Spacer()
//
//                HStack {
//                    ForEach(inventory.items, id: \.id) {
//                        CollectibleView(collectible: $0)
//                    }
//                }
//                .frame(minHeight: 100)
                
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
    
    let inventory = Inventory()
    
    static var previews: some View {
        
        GameView()
            .environmentObject(Game(inventory: Inventory()))
            .environmentObject(Inventory())
    }
}
