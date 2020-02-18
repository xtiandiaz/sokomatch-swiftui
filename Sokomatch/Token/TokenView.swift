//
//  Token.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 15.2.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import SwiftUI

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
        Circle()
            .fill(token.style.color)
            .frame(width: size, height: size)
            .position(position)

    }
    
    init(token: Token, size: CGFloat, stepLength: CGFloat) {
        self.token = token
        self.size = size
        self.stepLength = stepLength
    }
}


struct Token_Previews: PreviewProvider {
    static var previews: some View {
        TokenView(token: Blob.example, size: 50, stepLength: 50)
    }
}

