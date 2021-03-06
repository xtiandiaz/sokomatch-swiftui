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
    
    @Inject
    private var controlManager: ControlManager
    @Inject
    private var inventory: Slot
    
    @StateObject
    var game = Game()
    
    @State
    var unitSize: CGFloat?
    
    var body: some View {
        ZStack {
            GeometryReader {
                proxy in
                Color.black.onAppear {
                    unitSize = proxy.size.width / CGFloat(Self.viewportUWidth)
                }
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
                .padding(EdgeInsets(top: 0, leading: .xs, bottom: 0, trailing: .m))
                
                if let unitSize = unitSize {
                    StageView(stage: game.stage, unitSize: unitSize)
                }
                
                Spacer()
                
                HStack {
                    VStack(spacing: .xs) {
                        Image(systemName: "bolt.fill").opacity(0.25).zIndex(-1)
                        
                        SlotView(slot: inventory).frame(width: 80)
                        
                        Image(systemName: "repeat").opacity(0.25).zIndex(-1)
                    }
                    
                    Spacer()
                }
                .padding(EdgeInsets(top: 0, leading: .m, bottom: .m, trailing: .m))
            }
        }
        .gesture(controlManager.swipeGesture)
        .gesture(controlManager.doubleTapGesture)
    }
}

struct GameView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        GameView()
            .environmentObject(Game())
            .colorScheme(.dark)
    }
}
