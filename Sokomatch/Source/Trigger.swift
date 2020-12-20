//
//  Trigger.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 20.12.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import SwiftUI
import Emerald

struct Trigger: Token {
    
    let event: StageEvent
    var location: Location
    
    let id = UUID()
    let type: TokenType = .trigger
    var value = 1
    
    init(event: StageEvent, location: Location) {
        self.event = event
        self.location = location
    }
}

extension Trigger: Interactable {
    
    func interact(with other: Interactable) -> Token? {
        guard other.type == .actor else {
            return nil
        }
        return add(-value)
    }
}
