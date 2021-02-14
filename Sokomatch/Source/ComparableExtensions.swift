//
//  ComparableExtensions.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 14.2.2021.
//  Copyright © 2021 Berilio. All rights reserved.
//

import Foundation

extension Comparable {
    
    func clamped(_ a: Self, _ b: Self) -> Self {
        return min(max(self, a), b)
    }
}
