//
//  Wall.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 10.3.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import SwiftUI
import Emerald

struct Wall: Token, Hashable, Identifiable {
    
    let id = UUID()
    let type: TokenType = .wall
    
    var value = 1
}

struct WallView: View {
    
    var body: some View {
        Color.purple.opacity(0.25)
    }
}
