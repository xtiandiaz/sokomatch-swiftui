//
//  Boulder.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 10.3.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import SwiftUI
import Emerald

struct Wall: Token {
    
    let id = UUID()
    let type: TokenType = .wall
    var location: Location
    var value = 1
    
    init(location: Location) {
        self.location = location
    }
}

struct WallView: View {
    
    var body: some View {
        Rectangle()
            .fill(Color.gray)
    }
}
