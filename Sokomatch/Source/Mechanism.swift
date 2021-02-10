//
//  Mechanism.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 10.2.2021.
//  Copyright © 2021 Berilio. All rights reserved.
//

import SwiftUI
import Emerald

enum MechanismType {
    
    case lock(key: UUID)
}

struct Mechanism: Piece {
    
    let id = UUID()
    let type: TokenType = .mechanism
    let subtype: MechanismType
    
    init(subtype: MechanismType) {
        self.subtype = subtype
    }
}

extension Mechanism: Interactable {
    
    func canInteract(with other: Interactable) -> Bool {
        other is Avatar
    }
    
    func interact(with other: Interactable) -> Mechanism? {
        guard let avatar = other as? Avatar else {
            return self
        }
        
        switch subtype {
        case .lock:
            return avatar.activate(mechanism: self) ? nil : self
        }
    }
}

struct MechanismView: View {
    
    let mechanism: Mechanism
    
    var body: some View {
        switch mechanism.subtype {
        case .lock:
            Text("🔒").font(.title)
        }
    }
}
