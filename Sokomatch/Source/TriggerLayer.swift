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
        place(token: Trigger(event: event), at: location)
    }
    
    override func interact(with source: Interactable, at location: Location) {
        super.interact(with: source, at: location)
        
        if let event = self[location]?.event {
            eventSubject.send(event)
        }
    }
    
    override func isAvailable(location: Location) -> Bool {
        true
    }
    
    // MARK: Private
    
    private let eventSubject = PassthroughSubject<BoardEvent, Never>()
}
