//
//  Configurable.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 26.2.2021.
//  Copyright © 2021 Berilio. All rights reserved.
//

import Foundation

protocol Configurable { }

extension Configurable {
    
    @discardableResult
    func configure(_ block: (Self) -> Void) -> Self {
        block(self)
        return self
    }
}
