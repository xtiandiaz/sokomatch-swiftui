//
//  Doorway.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 4.2.2021.
//  Copyright © 2021 Berilio. All rights reserved.
//

import SwiftUI
import Emerald

struct Doorway: Piece {
    
    let id = UUID()
    let token: TokenType = .doorway
    let key: UUID
    
    var isLocked = true
}

struct DoorwayView: View {
    
    let doorway: Doorway
    
    var body: some View {
        if doorway.isLocked {
            Image(systemName: "lock.fill")
        }
    }
}
