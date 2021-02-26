//
//  Slot.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 21.2.2021.
//  Copyright © 2021 Berilio. All rights reserved.
//

import SwiftUI
import Combine

class Slot: ObservableObject {
    
    private(set) lazy var onDeferred: AnyPublisher<Card, Never> = deferralSubject.eraseToAnyPublisher()
    private(set) lazy var onExecuted: AnyPublisher<Card, Never> = executionSubject.eraseToAnyPublisher()
    
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
        guard let card = pop() else {
            return
        }
        
        _cards.insert(card, at: 0)
        
        deferralSubject.send(card)
    }
    
    func executeOne() {
        guard let card = pop() else {
            return
        }
        
        executionSubject.send(card)
    }
    
    // MARK: Private
    
    private var _cards = [Card]()
    
    private let deferralSubject = PassthroughSubject<Card, Never>()
    private let executionSubject = PassthroughSubject<Card, Never>()
}

struct SlotView: View {
    
    static let aspectRatio: CGFloat = 5/6
    static let cornerRadius: CGFloat = 8
    
    @ObservedObject
    var slot: Slot
    
    @State
    private var topCardOffsetY: CGFloat = 0
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Self.cornerRadius)
                .stroke(Color.white.opacity(0.15), lineWidth: 4)
                .aspectRatio(Self.aspectRatio, contentMode: .fit)
                .zIndex(-1)
            
            ForEach(Array(slot.cards.enumerated()), id: \.element) {
                CardView(card: $1)
                    .offset(x: 0, y: -CGFloat($0) * .xxxs)
                    .offset(x: 0, y: $0 == slot.cards.count-1 ? topCardOffsetY : 0)
                    .zIndex(Double($0))
            }
        }
        .gesture(
            DragGesture(minimumDistance: 0).onChanged {
                topCardOffsetY = $0.translation.height
            }.onEnded {
                _ in
                if topCardOffsetY < -.l {
                    slot.deferOne()
                } else if topCardOffsetY >= .l {
                    slot.executeOne()
                }
                
                topCardOffsetY = 0
            }
        )
    }
}

struct SlotView_Previews: PreviewProvider {
    
    static var previews: some View {
        SlotView(slot: Slot())
            .frame(width: 100, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
    }
}
