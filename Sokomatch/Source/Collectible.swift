//
//  Collectible.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 3.2.2021.
//  Copyright © 2021 Berilio. All rights reserved.
//

import SwiftUI
import Emerald

enum CollectibleType {
    case coin, key
}

struct Collectible: Piece {
    
    let id = UUID()
    let type: TokenType = .collectible
    let subtype: CollectibleType
    
    var value = 1
    
    init(subtype: CollectibleType) {
        self.subtype = subtype
    }
}

extension Collectible: Interactable {
    
    func canInteract(with other: Interactable) -> Bool {
        other is Avatar
    }
    
    func interact(with other: Interactable) -> Collectible? {
        other is Avatar ? nil : self
    }
}

struct CollectibleView: View {
    
    let collectible: Collectible
    
    var body: some View {
        switch collectible.subtype {
        case .coin:
            Circle().fill(Color.yellow).scaleEffect(0.25)
        case .key:
            Image(systemName: "key.fill")
        }
    }
}
