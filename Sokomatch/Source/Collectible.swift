//
//  Collectible.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 3.2.2021.
//  Copyright © 2021 Berilio. All rights reserved.
//

import SwiftUI
import Emerald

enum CollectibleType {
    
    case coin(value: Int)
    case key
    case card(type: CardType, value: Int)
}

struct Collectible: Layerable {
    
    let id = UUID()
    let token: TokenType = .collectible
    let type: CollectibleType
    
    var location: Location
    
    init(type: CollectibleType, location: Location) {
        self.type = type
        self.location = location
    }
    
    func canInteract(with other: Token) -> Bool {
        other is Avatar
    }
    
    func interact(with other: Token) -> Collectible? {
        other is Avatar ? nil : self
    }
}

extension Collectible: Equatable {
    
    static func ==(lhs: Collectible, rhs: Collectible) -> Bool {
        lhs.id == rhs.id
    }
}

struct CollectibleView: View {
    
    let collectible: Collectible
    
    var body: some View {
        switch collectible.type {
        case .coin:
            Circle().fill(Color.yellow).scaleEffect(0.25)
        case .key:
            Image(systemName: "key.fill").resizableToFit().scaleEffect(0.5)
        case .card(_, _):
            ZStack {
                Image(systemName: "questionmark")
                    .resizableToFit()
                    .foregroundColor(Color.black)
            }
            .padding(.xxs)
            .background(Color.white.cornerRadius(4))
            .aspectRatio(SlotView.aspectRatio, contentMode: .fit)
            .scaleEffect(0.5)
        }
    }
}

struct CollectibleView_Previews: PreviewProvider {
    
    static var previews: some View {
        CollectibleView(
            collectible: .init(type: .card(type: .random(), value: 1), location: .zero)
        )
        .frame(width: 30, height: 30, alignment: .center)
        .background(Color.black)
    }
}

// MARK: - Codable

extension CollectibleType: Codable {
    
    enum CodingKeys: CodingKey {
        case coin, key
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        switch container.allKeys.first {
        case .coin:
            self = .coin(value: try container.decode(Int.self, forKey: .coin))
        case .key:
            self = .key
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
        
//        switch self {
//        case .coin(let value):
//            try container.encode(value, forKey: .coin)
//        case .key:
//            try container.encode(true, forKey: .key)
//        case .card(let type, let value):
////            try container.encode(value, forKey: .)
//            break
//        }
    }
}

extension Collectible: Codable {
    
    enum CodingKeys: String, CodingKey {
        case type, value, location
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        type = try container.decode(CollectibleType.self, forKey: .type)
        location = try container.decode(Location.self, forKey: .location)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(type, forKey: .type)
    }
}
