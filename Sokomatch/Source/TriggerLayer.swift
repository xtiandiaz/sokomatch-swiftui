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
        place(token: Trigger(type: .event(event), location: location))
    }
    
    func create(withKey key: UUID, at location: Location) {
        place(token: Trigger(type: .lock(key: key), location: location))
    }
    
    override func onTokenChanged(from: Trigger?, to: Trigger?, at: Location) {
        guard let trigger = from else {
            return
        }
        
        switch trigger.type {
        case .event(let event):
            eventSubject.send(event)
        case .lock(let key) where to == nil:
            eventSubject.send(.unlocked(key: key))
        default:
            break
        }
    }
    
    override func isObstructive(location: Location, for token: Token?) -> Bool {
        false
    }
    
    // MARK: Private
    
    private let eventSubject = PassthroughSubject<BoardEvent, Never>()
}
