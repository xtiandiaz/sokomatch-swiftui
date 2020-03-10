//
//  TokenStyle.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 18.2.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import SwiftUI

struct TokenStyle {
    
    let shape: TokenShape
    let fillColor: Color
    let borderColor: Color
    
    init(shape: TokenShape, fillColor: Color, borderColor: Color) {
        self.shape = shape
        self.fillColor = fillColor
        self.borderColor = borderColor
    }
    
    init(fillColor: Color, borderColor: Color = Color.clear) {
        self.init(shape: .circle, fillColor: fillColor, borderColor: borderColor)
    }
}
