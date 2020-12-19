//
//  Target.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 9.12.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import SwiftUI
import Emerald

struct Target: Token {
    
    let id = UUID()
    let type: TokenType = .target
    var location: Location
    var value = Int.random(in: 2..<5)
    
    let requirement: TokenType = [.water, .fire].randomElement()!
    
    init(location: Location) {
        self.location = location
    }
}

extension Target: Interactable {
    
    func interact(with other: Interactable) -> Token? {
        guard other.type == requirement, other.value >= value else {
            return nil
        }
        return add(-value)
    }
}

struct TargetView: View {
    
    let target: Target
    
    @State var rotation: Double = 0
    
    var body: some View {
        Circle()
            .strokeBorder(style: StrokeStyle(lineWidth: 4, dash: [8]))
            .foregroundColor(target.requirement.color)
            .rotationEffect(Angle(degrees: rotation))
            .animation(Animation.linear(duration: 5.0).repeatForever(autoreverses: false))
            .onAppear {
                rotation = 360
            }
    }
}
