//
//  CGExtensions.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 13.2.2021.
//  Copyright © 2021 Berilio. All rights reserved.
//

import CoreGraphics

extension CGSize {
    
    init(widthAndHeight: CGFloat) {
        self.init(width: widthAndHeight, height: widthAndHeight)
    }
    
    static func *(lhs: CGSize, rhs: CGFloat) -> CGSize {
        CGSize(width: lhs.width * rhs, height: lhs.height * rhs)
    }
    
    static func *(lhs: CGFloat, rhs: CGSize) -> CGSize {
        rhs * lhs
    }
    
    static func +(lhs: CGSize, rhs: CGSize) -> CGSize {
        CGSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
    }
}

extension CGPoint {
    
    static func /(lhs: CGPoint, rhs: CGFloat) -> CGPoint {
        CGPoint(x: lhs.x / rhs, y: lhs.y / rhs)
    }
}
