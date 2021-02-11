//
//  TriggerLayer.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 9.2.2021.
//  Copyright © 2021 Berilio. All rights reserved.
//

import SwiftUI
import Combine
import Emerald

class TriggerLayer: BoardLayer<Trigger> {
    
    var onTriggered: AnyPublisher<BoardEvent, Never> {
        eventSubject.eraseToAnyPublisher()
    }
    
    func create(withEvent event: BoardEvent, at location: Location) {
        place(token: Trigger(subtype: .event(event)), at: location)
    }
    
    func create(withKey key: UUID, at location: Location) {
        place(token: Trigger(subtype: .lock(key: key)), at: location)
    }
    
    override func interact(with source: Interactable, at location: Location) {
        let trigger = self[location]
        
        super.interact(with: source, at: location)
        
        if let trigger = trigger {
            switch trigger.subtype {
            case .event(let event):
                eventSubject.send(event)
            case .lock(let key):
                if self[location] == nil {
                    eventSubject.send(.unlocked(key: key))
                }
            }
        }
    }
    
    override func isObstructive(location: Location) -> Bool {
        false
    }
    
    // MARK: Private
    
    private let eventSubject = PassthroughSubject<BoardEvent, Never>()
}

struct TriggerLayerView: View {
    
    @ObservedObject
    var layer: TriggerLayer
    
    var body: some View {
        ForEach(layer.spots, id: \.self) {
            TriggerView(trigger: $0.token)
                .position(layer.position(for: $0.location))
                .frame(width: layer.unitSize, height: layer.unitSize)
        }
    }
}
