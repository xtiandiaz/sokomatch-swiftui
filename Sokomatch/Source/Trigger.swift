//
//  Trigger.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 20.12.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import SwiftUI
import Emerald

enum TriggerType {
    
    case event(BoardEvent), lock(key: UUID)
}

struct Trigger: Piece {
    
    let id = UUID()
    let type: TokenType = .trigger
    let subtype: TriggerType
    
    init(subtype: TriggerType) {
        self.subtype = subtype
    }
}

extension Trigger: Interactable {
    
    func canInteract(with other: Interactable) -> Bool {
        other is Avatar
    }
    
    func interact(with other: Interactable) -> Trigger? {
        guard let avatar = other as? Avatar else {
            return self
        }
        
        switch subtype {
        case .lock(let key):
            return avatar.hasKey(key) ? nil : self
        default:
            return self
        }
    }
}

struct TriggerView: View {
    
    let trigger: Trigger
    
    var body: some View {
        switch trigger.subtype {
        case .lock(_):
            Image(systemName: "circles.hexagongrid.fill")
                .font(.title)
                .foregroundColor(Color.black).opacity(0.15)
        default:
            Color.clear
        }
    }
}
