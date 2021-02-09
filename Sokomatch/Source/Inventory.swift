//
//  Inventory.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 8.2.2021.
//  Copyright © 2021 Berilio. All rights reserved.
//

import SwiftUI

class Inventory: ObservableObject {
    
    @Published
    private(set) var items = [Collectible]()
    
    func add(_ item: Collectible) {
        items.append(item)
    }
    
    func remove(_ item: Collectible) {
        if let index = items.firstIndex(of: item) {
            items.remove(at: index)
        }
    }
}
