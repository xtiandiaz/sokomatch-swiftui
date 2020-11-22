//
//  NavigationController.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 22.11.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import Foundation
import Emerald

class NavigationController {
    
    init(map: Map) {
        self.map = map
    }
    
    func move(token: Token, from origin: Location, toward direction: Direction) -> Location {
        let nextLocation = origin.shifted(toward: direction)
        
        guard map.isValid(location: nextLocation) else {
            return origin
        }
        
        guard map.isAvailable(location: nextLocation) else {
            return origin
        }
        
        return move(token: token, from: nextLocation, toward: direction)
    }
    
    
    /*
     if !isAvailable(location: next) {
         guard
             let other = self.token(atLocation: next),
             token.canInteract(with: other)
         else {
             return origin
         }
         
         let result = token.interact(with: other)
         
         DispatchQueue.main.asyncAfter(deadline: .now() + Self.transitionDuration) { [weak self] in
             guard var result = result else {
                 self?.removeAndClear(token: token)
                 self?.removeAndClear(token: other)
                 return
             }
             
             self?.remove(token: token)
             self?.remove(token: other)
             
             result.location = next
             
             self?.place(token: result)
         }
         return next
     }
     */
    
    // MARK: Private
    
    private let map: Map
}
