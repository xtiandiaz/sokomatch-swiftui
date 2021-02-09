//
//  Token.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 15.2.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import SwiftUI
import Emerald

//struct TokenView: View {
//    
//    let token: Token
//    let size: CGFloat
//    
//    var color: Color {
//        switch token.type {
//        case .collectible: return Color.yellow
//        case .avatar: return Color.white
//        default: return Color.black
//        }
//    }
//    
//    var scale: CGFloat {
//        switch token.type {
//        case .collectible: return 0.25
//        default: return 1
//        }
//    }
//    
//    var body: some View {
//        ZStack {
//            switch token {
//            case is Wall: WallView()
//            case is Collectible: BlobView(value: token.value, color: token.type.color, scale: 0.25)
//            case let doorway as Doorway: DoorwayView(edge: doorway.edge)
//            case let avatar as Avatar: AvatarView(avatar: avatar)
//            default: Circle()
//            }
//        }
//        .frame(width: size, height: size)
//    }
//}

private struct BlobView: View {
    
    let value: Int
    let color: Color
    let scale: CGFloat
    
    init(value: Int, color: Color, scale: CGFloat = 1) {
        self.value = value
        self.color = color
        self.scale = scale
    }
    
    var body: some View {
        ZStack {
            Circle().fill(color)
            
            ValueView(value: value)
        }
        .scaleEffect(scale)
    }
}

private struct MarkerView: View {
    
    let value: Int
    let color: Color
    
    @State
    var rotation: Double = 0
    
    var body: some View {
        ZStack {
            Circle()
                .strokeBorder(style: StrokeStyle(lineWidth: 4, dash: [8]))
                .foregroundColor(color)
                .rotationEffect(Angle(degrees: rotation))
                .animation(Animation.linear(duration: 5.0).repeatForever(autoreverses: false))
                .onAppear {
                    rotation = 360
                }
            
            ValueView(value: value)
        }
    }
}


private struct ValueView: View {
    
    let value: Int
    
    init?(value: Int) {
        guard value > 1 else {
            return nil
        }
        self.value = value
    }
    
    var body: some View {
        Text("\(value)")
            .font(.title)
            .foregroundColor(Color.white)
    }
}


struct Token_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            
        }
        .previewLayout(.fixed(width: 200, height: 200))
        .background(Color(UIColor.systemBackground))
        .colorScheme(.dark)
    }
}
