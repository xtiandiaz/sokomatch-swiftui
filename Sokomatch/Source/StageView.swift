//
//  StageView.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 22.2.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import SwiftUI
import Emerald

struct StageView: View {
    
    @ObservedObject
    var stage: Stage
    
    let unitSize: CGFloat
    
    var body: some View {
        ZStack {
            Color.black
//            Image("forest")
//                .resizable(resizingMode: .tile)
            
            if let board = stage.board {
                BoardView(board: board, unitSize: unitSize)
                    .transition(AnyTransition.opacity.animation(.default))
            }
            
//            VStack {
//                Spacer()
//
//                HStack {
//                    VStack(spacing: .s) {
//                        IconButton(icon: Image(systemName: "staroflife.fill"), onTapped: stage.reset)
//                        IconButton(icon: Image(systemName: "cross.fill"), onTapped: stage.reset)
//                    }
//                    Spacer()
//                }
//                .frame(maxWidth: .infinity)
//            }
//            .padding(.m)
        }
        .gesture(DragGesture(minimumDistance: unitSize / 2).onEnded {
            let dir: Direction
            let deltaX = $0.translation.width
            let deltaY = $0.translation.height

            if abs(deltaX) > abs(deltaY) {
                dir = deltaX > 0 ? .right : .left
            } else {
                dir = deltaY > 0 ? .down : .up
            }

            stage.board?.move(toward: dir)
        })
        .gesture(TapGesture(count: 2).onEnded {
            stage.board?.command2()
        })
    }
}

struct StageView_Previews: PreviewProvider {
    static var previews: some View {
        StageView(stage: Stage(inventory: Inventory()), unitSize: 30)
    }
}
