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
    
    static let viewportUWidth = 9
    static let viewportUHeight = 9
    
    @EnvironmentObject
    var game: Game
    @EnvironmentObject
    var inventory: Inventory
    
    @State
    var unitSize: CGFloat?
    
    var body: some View {
        ZStack {
            GeometryReader {
                proxy in
                Color.clear.onAppear {
                    unitSize = proxy.size.width / CGFloat(Self.viewportUWidth)
                }
            }
            
            if let unitSize = unitSize {
                StageView(stage: game.stage, unitSize: unitSize)
            }
            
            VStack {
                Text("\(game.score)").font(.title)
                
                Spacer()
                
                Button("Reset") {
                    game.reset()
                }
            }
            .padding()
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
