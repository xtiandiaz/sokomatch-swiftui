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
                HStack {
                    IconButton(
                        icon: Image(systemName: "repeat"),
                        iconColor: .white,
                        backgroundColor: .clear,
                        onTapped: game.reset
                    )
                    Spacer()
                    Text("\(game.score)").font(.largeTitle)
                }
                .frame(maxWidth: .infinity)
                
                Spacer()
            }
            .padding(EdgeInsets(top: .xs, leading: .xs, bottom: 0, trailing: .m))
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
