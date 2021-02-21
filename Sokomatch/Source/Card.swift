//
//  Card.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 21.2.2021.
//  Copyright © 2021 Berilio. All rights reserved.
//

import SwiftUI

enum CardType: CaseIterable {
    
    case hover, attraction
    
    var color: Color {
        switch self {
        case .hover: return .grayDark
        case .attraction: return .grayDark
        }
    }
    
    var content: String {
        switch self {
        case .attraction: return "🧲"
        case .hover: return "👻"
        }
    }
    
    static func random() -> CardType {
        Self.allCases.randomElement()!
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
            
            Text(card.type.content)
                .font(.largeTitle)
                .zIndex(1)
        }
        .transition(AnyTransition.opacity.combined(with: .scale).animation(.default))
    }
}
