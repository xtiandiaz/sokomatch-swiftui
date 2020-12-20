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
    
    var body: some View {
        ZStack {
            GeometryReader {
                proxy in
                Color.clear.onAppear {
                    stage.setup(size: proxy.size)
                }
            }
            
            if let board = stage.board {
                BoardView(board: board)
                    .transition(AnyTransition.opacity.animation(.default))
            }
        }
    }
}

//extension Direction {
//
//    static var random: Direction {
//        [.up, .right, .down, .left].randomElement()!
//    }
//}
//
//extension AnyTransition {
//
//    static func flip(direction: Direction) -> AnyTransition {
//        AnyTransition.asymmetric(
//            insertion: AnyTransition.flip(mode: .insertion, direction: direction).animation(
//                Animation.easeOut(duration: 1).delay(1)
//            ),
//            removal: AnyTransition.flip(mode: .removal, direction: direction).animation(
//                Animation.easeIn(duration: 1).delay(0)
//            )
//        )
//    }
//
//    static func flip(mode: FlipTransitionModifier.Mode, direction: Direction) -> AnyTransition {
//        .modifier(
//            active: FlipTransitionModifier(mode: mode, direction: direction),
//            identity: FlipTransitionModifier(degrees: 0, direction: direction))
//    }
//}
//
//struct FlipTransitionModifier: ViewModifier {
//
//    enum Mode {
//
//        case insertion, removal
//    }
//
//    let axis: CGPoint
//    let degrees: Double
//
//    init(mode: Mode, direction: Direction) {
//        switch mode {
//        case .insertion:
//            degrees = -90
//        case .removal:
//            degrees = 90
//        }
//
//        axis = Self.axis(for: direction)
//    }
//
//    init(degrees: Double, direction: Direction) {
//        self.degrees = degrees
//
//        axis = Self.axis(for: direction)
//    }
//
//    func body(content: Content) -> some View {
//        content.rotation3DEffect(Angle(degrees: degrees), axis: (x: axis.x, y: axis.y, z: 0))
//    }
//
//    // MARK: Private
//
//    private static func axis(for direction: Direction) -> CGPoint {
//        switch direction {
//        case .up, .down:
//            return CGPoint(x: 1, y: 0)
//        default:
//            return CGPoint(x: 0, y: 1)
//        }
//    }
//}
