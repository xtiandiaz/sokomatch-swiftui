//
//  Doorway.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 4.2.2021.
//  Copyright © 2021 Berilio. All rights reserved.
//

import SwiftUI
import Emerald

struct Doorway: Token {
    
    let id = UUID()
    let type: TokenType = .doorway
    let edge: Edge
    
    var value = 1
    var location: Location = .zero
    
    init(edge: Edge) {
        self.edge = edge
    }
}

//extension Doorway: Interactable {
//    
//    func canInteract(with other: Interactable) -> Bool {
//        false
//    }
//    
//    func interact(with other: Interactable) -> Token? {
//        guard other.type == .avatar else {
//            return nil
//        }
//        return self
//    }
//}

struct DoorwayView: View {
    
    let edge: Edge
    
    var body: some View {
        Rectangle().fill(
            LinearGradient(
                gradient: Gradient(colors: [Color.black.opacity(0.25), Color.purple.opacity(0.25)]),
                startPoint: edge.gradientStartPoint,
                endPoint: edge.gradientEndPoint))
    }
}

private extension Edge {
    
    var gradientStartPoint: UnitPoint {
        switch self {
        case .top: return .top
        case .left: return .leading
        case .bottom: return .bottom
        case .right: return .trailing
        }
    }
    
    var gradientEndPoint: UnitPoint {
        switch self {
        case .top: return .bottom
        case .left: return .trailing
        case .bottom: return .top
        case .right: return .leading
        }
    }
}
