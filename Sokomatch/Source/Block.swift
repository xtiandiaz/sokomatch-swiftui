//
//  Block.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 6.3.2021.
//  Copyright © 2021 Berilio. All rights reserved.
//

import SwiftUI

class Block: Movable, ObservableObject {
    
    init(location: Location) {
        super.init(type: .block, location: location)
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
}
