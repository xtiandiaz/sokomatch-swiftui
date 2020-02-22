//
//  Direction.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 15.2.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import UIKit

enum Direction: UInt {
    
    case undefined = 0, up = 1, right = 2, down = 4, left = 8
    
    static func fromSwipe(direction: UISwipeGestureRecognizer.Direction) -> Direction {
        switch direction {
        case .up:
            return Direction.up
        case .right:
            return Direction.right
        case .down:
            return Direction.down
        case .left:
            return Direction.left
        default:
            return Direction.undefined
        }
    }
}
