//
//  Card.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 21.2.2021.
//  Copyright © 2021 Berilio. All rights reserved.
//

import SwiftUI

enum CardType: Hashable {
    
    case ability(AvatarAbility), mode(AvatarMode)
    
    var color: Color {
        .grayDark
    }
    
    var content: String? {
        switch self {
        case .ability(let ability):
            switch ability {
            case .magnesis:
                return "🧲"
            }
        case .mode(let mode):
            switch mode {
            case .ghost: return "👻"
            case .mighty: return "💪"
            default: return nil
            }
        }
    }
    
    static func random() -> CardType {
        [.ability(.magnesis), .mode(.ghost), .mode(.mighty)].randomElement()!
    }
}

struct Card: Identifiable, Hashable {
    
    let id = UUID()
    let type: CardType
    let value: Int
    
    init(type: CardType, value: Int = 1) {
        self.type = type
        self.value = value
    }
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        lhs.id == rhs.id
    }
}

struct CardView: View {
    
    @State
    var card: Card
    
    var body: some View {
        ZStack {
            card.type.color
//                .overlay(
//                    LinearGradient(gradient: .init(colors: [.clear, Color.black.opacity(0.25)]), startPoint: .top, endPoint: .bottom)
//                )
                .cornerRadius(SlotView.cornerRadius)
                .aspectRatio(SlotView.aspectRatio, contentMode: .fit)
                .shadow(radius: 4).shadow(radius: 4)
                .zIndex(0)
            
            if let content = card.type.content {
                Text(content).font(.largeTitle).zIndex(1)
            }
        }
        .transition(AnyTransition.opacity.combined(with: .scale).animation(.default))
    }
}
