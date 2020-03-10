//
//  TokenStyle.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 18.2.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import SwiftUI

struct TokenStyle {
    
    let color: Color
    let shape: TokenShape
    
    init(shape: TokenShape, color: Color) {
        self.shape = shape
        self.color = color
    }
    
    init(color: Color) {
        self.init(shape: .circle, color: color)
    }
}
