//
//  TriggerLayer.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 9.2.2021.
//  Copyright © 2021 Berilio. All rights reserved.
//

import SwiftUI
import Combine

class TriggerLayer: BoardLayer<Trigger> {
    
    var onTriggered: AnyPublisher<BoardEvent, Never> {
        eventSubject.eraseToAnyPublisher()
    }
    
    func create(withEvent event: BoardEvent, at location: Location) {
        place(token: Trigger(type: .event(event), location: location))
    }
    
    func createLock(withKey key: UUID, at location: Location) {
        place(token: Trigger(type: .lock(key: key), location: location))
    }
    
    func createSwitch(withEmblem emblem: Emblem, enabled: Bool, at location: Location) {
        place(token: Trigger(type: .switch(emblem: emblem, enabled: enabled), location: location))
    }
    
    override func affect(with token: Token, at location: Location) {
        guard
            let avatar = token as? Avatar,
            let trigger = self[location]
        else {
            return
        }
        
        switch trigger.type {
        case .lock(let key) where avatar.hasKey(key):
            eventSubject.send(.unlocked(key: key))
        case .event(let event):
            eventSubject.send(event)
        case .switch(let emblem, let enabled):
            if !enabled {
                createSwitch(withEmblem: emblem, enabled: true, at: location)
            }
        default:
            break
        }
    }
    
    // MARK: Private
    
    private let eventSubject = PassthroughSubject<BoardEvent, Never>()
}

struct TriggerLayerView: BoardLayerView {
    
    @ObservedObject
    var layer: TriggerLayer
    
    let unitSize: CGFloat
    
    var body: some View {
        ForEach(layer.tokens) {
            TriggerView(trigger: $0, unitSize: unitSize)
                .frame(width: unitSize, height: unitSize)
                .position(position(for: $0.location))
        }
    }
}
