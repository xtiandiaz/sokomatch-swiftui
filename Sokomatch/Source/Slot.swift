//
//  Slot.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 21.2.2021.
//  Copyright © 2021 Berilio. All rights reserved.
//

import SwiftUI

class Slot: ObservableObject {
    
    var cards: [Card] {
        _cards
    }
    
    func push(card: Card) {
        guard !_cards.contains(card) else {
            return
        }
        
        objectWillChange.send()
        
        _cards.append(card)
    }
    
    func pop() -> Card? {
        guard !_cards.isEmpty else {
            return nil
        }
        
        objectWillChange.send()
        
        return _cards.removeLast()
    }
    
    func deferOne() {
        guard !_cards.isEmpty else {
            return
        }
        
        _cards.insert(pop()!, at: 0)
    }
    
    // MARK: Private
    
    private var _cards = [Card]()
}

struct SlotView: View {
    
    static let aspectRatio: CGFloat = 5/6
    static let cornerRadius: CGFloat = 8
    
    @ObservedObject
    var slot: Slot
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Self.cornerRadius)
                .stroke(Color.white.opacity(0.15), lineWidth: 4)
                .aspectRatio(Self.aspectRatio, contentMode: .fit)
            
            ForEach(Array(slot.cards.enumerated()), id: \.element) {
                CardView(card: $1)
                    .offset(x: 0, y: -CGFloat($0) * .xxxs)
                    .zIndex(Double($0))
            }
        }
    }
}

struct SlotView_Previews: PreviewProvider {
    
    static var previews: some View {
        SlotView(slot: Slot())
            .frame(width: 100, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
    }
}
