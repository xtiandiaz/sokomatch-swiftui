//
//  Trigger.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 20.12.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import SwiftUI
import Emerald

struct Trigger: Piece {
    
    let id = UUID()
    let type: TokenType = .trigger
    let event: BoardEvent
    
    init(event: BoardEvent) {
        self.event = event
    }
}

extension Trigger: Interactable {
    
    func canInteract(with other: Interactable) -> Bool {
        other is Avatar
    }
    
    func interact(with other: Interactable) -> Trigger? {
        self
    }
}
