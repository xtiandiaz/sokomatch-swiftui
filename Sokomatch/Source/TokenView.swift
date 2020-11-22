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
    @State private var scale: CGFloat = 0.1
    
    var position: CGPoint {
        let location = token.location
        return CGPoint(
            x: CGFloat(location.x) * stepLength + stepLength / 2,
            y: CGFloat(location.y) * stepLength + stepLength / 2)
    }
    
    var body: some View {
        ZStack {
            TokenBodyView(style: token.style)
            TokenValueView(token: token)
        }
        .frame(width: size, height: size)
        .transition(.scale)
        .scaleEffect(scale)
        .position(position)
        .onAppear {
            withAnimation(.spring()) {
                self.scale = 1.0
            }
        }
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


struct Token_Previews: PreviewProvider {
    static var previews: some View {
        TokenView(token: Water(location: Location.zero), size: 50, stepLength: 50)
    }
}

