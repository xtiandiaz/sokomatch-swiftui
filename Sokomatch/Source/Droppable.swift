//
//  Droppable.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 24.2.2021.
//  Copyright © 2021 Berilio. All rights reserved.
//

import SwiftUI

enum DroppableType {
    
    case bomb
}

class Droppable: Layerable {
    
    let id = UUID()
    let category: TokenCategory = .droppable
    let type: DroppableType
    
    var location: Location
    
    let collisionMask: [TokenCategory] = []
    let interactionMask: [TokenCategory] = []
    
    init(type: DroppableType, location: Location) {
        self.type = type
        self.location = location
    }
    
    func affect(with other: Token) -> Self? {
        return self
    }
}

class Bomb: Droppable, ObservableObject {
    
    @Published
    private(set) var isDetonated = false
    
    init(location: Location) {
        super.init(type: .bomb, location: location)
    }
    
    func detonate(after delay: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.isDetonated = true
        }
    }
}

struct BombView: View {
    
    @ObservedObject
    var bomb: Bomb
    
    var body: some View {
        Circle()
            .fill(bomb.isDetonated ? Color.red : Color.blue)
            .opacity(bomb.isDetonated ? 0.5 : 1)
            .scaleEffect(bomb.isDetonated ? 3 : 0.5)
            .animation(.easeOut(duration: 0.2))
            .transition(AnyTransition.opacity.animation(.default))
    }
}

extension AnyTransition {
    
    static var explosion: AnyTransition {
        scale(scale: 4)
    }
}
