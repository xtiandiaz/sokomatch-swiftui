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
            
            VStack(spacing: 0) {
                ZStack(alignment: .top) {
                    HStack {
                        Text("\(game.score)").font(.title)
                        
                        Spacer()
                        
                        IconButton(
                            icon: Image(systemName: "repeat"),
                            iconColor: .white,
                            backgroundColor: .clear,
                            onTapped: game.reset
                        )
                    }
                    .padding(.leading, .xs)
                    
                    VStack(spacing: .xxs) {
                        Image(systemName: "arrow.up").opacity(0.25).zIndex(-1)
                        
                        SlotView(slot: inventory).frame(width: .xxl)
                        
                        Image(systemName: "arrow.down").opacity(0.25).zIndex(-1)
                    }
                }
                .padding(EdgeInsets(top: 0, leading: .xs, bottom: .s, trailing: .xs))
                
                if let unitSize = unitSize {
                    StageView(stage: game.stage, unitSize: unitSize)
                }
                
                Spacer()
            }
        }
        .gesture(controlManager.swipeGesture)
        .gesture(controlManager.doubleTapGesture)
    }
}

struct GameView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        GameView()
            .colorScheme(.dark)
    }
}
