//
//  Token.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 15.2.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import SwiftUI
import Emerald

struct TokenView: View {
    
    private let token: Token
    private let size: CGFloat
    private let stepLength: CGFloat
    
    var position: CGPoint {
        let location = token.location
        return CGPoint(
            x: CGFloat(location.x) * stepLength + stepLength / 2,
            y: CGFloat(location.y) * stepLength + stepLength / 2)
    }
    
    var body: some View {
        ZStack {
            switch token {
            case is Wall: WallView()
            case is Water, is Fire: BlobView(value: token.value, color: token.type.color)
            case is Bomb: BombView()
            case is Actor: ActorView()
            case is Trigger: MarkerView(value: 0, color: Color.white)
            case let target as Target: MarkerView(value: token.value, color: target.requirement.color)
            default: Circle()
            }
        }
        .frame(width: size, height: size)
        .transition(.asymmetric(insertion: .scale, removal: .identity))
        .position(position)
    }
    
    init?(token: Token?, size: CGFloat, stepLength: CGFloat) {
        guard let token = token else {
            return nil
        }
        
        self.token = token
        self.size = size
        self.stepLength = stepLength
    }
}

private struct BlobView: View {
    
    let value: Int
    let color: Color
    
    var body: some View {
        ZStack {
            Circle().fill(color)
            
            ValueView(value: value)
        }
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
            TokenView(token: Water(location: Location.zero), size: 50, stepLength: 50)
            
            BlobView(value: 4, color: Color.purple)
        }
        .previewLayout(.fixed(width: 200, height: 200))
        .background(Color(UIColor.systemBackground))
        .colorScheme(.dark)
    }
}
