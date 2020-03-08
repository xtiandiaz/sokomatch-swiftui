//
//  TokenStyle.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 18.2.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import SwiftUI

struct TokenStyle {
    
    static let red = TokenStyle(color: .red)
    static let green = TokenStyle(color: .green)
    static let blue = TokenStyle(color: .blue)
    
    var color: Color
    var image: String?
}
