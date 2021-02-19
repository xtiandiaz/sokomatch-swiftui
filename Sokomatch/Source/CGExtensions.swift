//
//  CGExtensions.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 13.2.2021.
//  Copyright © 2021 Berilio. All rights reserved.
//

import CoreGraphics

extension CGRect {
    
    var center: CGPoint {
        CGPoint(x: midX, y: midY)
    }
}

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
    
    static func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    static func /(lhs: CGPoint, rhs: CGFloat) -> CGPoint {
        CGPoint(x: lhs.x / rhs, y: lhs.y / rhs)
    }
}

extension CGFloat {
    
    /// 4
    static let xxxs = CGFloat(4)
    /// 8
    static let xxs = CGFloat(8)
    /// 12
    static let xs = CGFloat(12)
    /// 16
    static let s = CGFloat(16)
    /// 24
    static let m = CGFloat(24)
    /// 32
    static let l = CGFloat(32)
    /// 48
    static let xl = CGFloat(48)
    /// 64
    static let xxl = CGFloat(64)
}
