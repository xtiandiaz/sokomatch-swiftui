//
//  Map.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 22.11.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import Foundation
import Emerald

protocol Map {
    
    func isValid(location: Location) -> Bool
    func isAvailable(location: Location) -> Bool
    
    func token(at: Location) -> Token?
    func remove(token: Token)
    func place(token: Token, at location: Location)
    func move(token: Token, to location: Location)
    
}
