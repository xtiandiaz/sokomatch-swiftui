//
//  Access.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 4.2.2021.
//  Copyright © 2021 Berilio. All rights reserved.
//

import SwiftUI
import Emerald

struct Access: Piece {
    
    let id = UUID()
    let token: TokenType = .access
    let key: UUID
    
    var location: Location
    var isLocked = true
    
    func canInteract(with other: Token) -> Bool {
        false
    }
    
    func interact(with other: Token) -> Access? {
        self
    }
}

struct AccessView: View {
    
    let access: Access
    
    var body: some View {
        if access.isLocked {
            Image(systemName: "lock.fill")
        }
    }
}
