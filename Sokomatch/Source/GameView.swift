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
    var inventory: Slot
    
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
                    
                    Text("\(game.score)").font(.title)
                }
                
                Spacer()
            }
            .padding(EdgeInsets(top: .xs, leading: .xxs, bottom: 0, trailing: .m))
            
            VStack {
                
                VStack(spacing: .xxs) {
                    Image(systemName: "arrow.up").opacity(0.25)
                    
                    SlotView(slot: inventory).frame(width: .xxl)
                    
                    Image(systemName: "arrow.down").opacity(0.25)
                }
                
                Spacer()
            }
            .padding(.top, .xxs)
        }
    }
}

struct GameView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        let inventory = Slot()
        
        GameView()
            .environmentObject(Game(inventory: inventory))
            .environmentObject(inventory)
            .colorScheme(.dark)
    }
}
