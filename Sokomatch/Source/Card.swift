//
//  Card.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 21.2.2021.
//  Copyright © 2021 Berilio. All rights reserved.
//

import SwiftUI

enum CardType: Hashable {
    
    case ability(Avatar.Ability), mode(Avatar.Mode)
    
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

// MARK: - Codable

extension CardType: Codable {
    
    enum CodingKeys: String, CodingKey {
        case ability, mode
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        switch container.allKeys.first {
        case .ability:
            self = .ability(try container.decode(Avatar.Ability.self, forKey: .ability))
        case .mode:
            self = .mode(try container.decode(Avatar.Mode.self, forKey: .mode))
        default:
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: container.codingPath,
                    debugDescription: "Unable to decode \(Self.self)"
                )
            )
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .ability(let ability):
            try container.encode(ability, forKey: .ability)
        case .mode(let mode):
            try container.encode(mode, forKey: .mode)
        }
    }
}
