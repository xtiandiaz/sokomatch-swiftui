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
    
    let id = UUID()
    let type: TokenType = .trigger
    let event: StageEvent
    
    var value = 1
    var location: Location = .zero
    
    init(event: StageEvent) {
        self.event = event
    }
}

extension Trigger: Interactable {
    
    func interact(with other: Interactable) -> Token? {
        guard other.type == .avatar else {
            return nil
        }
        return add(-value)
    }
}
