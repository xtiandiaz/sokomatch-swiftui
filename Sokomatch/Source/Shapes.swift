//
//  Shapes.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 18.2.2021.
//  Copyright © 2021 Berilio. All rights reserved.
//

import SwiftUI

struct Petal: Shape {
    
    let angle: Angle
    let breadth: Angle
        
    func path(in rect: CGRect) -> Path {
        let h = Double(min(rect.width, rect.height)) / 2.0
        let to = CGPoint(x: cos(angle.radians) * h, y: sin(angle.radians) * h) + rect.center
        let ctrl1 = CGPoint(
            x: cos((angle + breadth).radians) * h,
            y: sin((angle + breadth).radians) * h) + rect.center
        let ctrl2 = CGPoint(
            x: cos((angle - breadth).radians) * h,
            y: sin((angle - breadth).radians) * h) + rect.center
        
        var path = Path()
        path.move(to: rect.center)
        path.addQuadCurve(to: to, control: ctrl1)
        path.addQuadCurve(to: rect.center, control: ctrl2)
            
        return path
    }
}

struct Propeller: Shape {
    
    let petalCount: Int
    let petalBreadth: Angle
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        for degrees in stride(from: 0, to: 360.0, by: 360.0 / 5) {
            path.addPath(
                Petal(angle: Angle(degrees: degrees), breadth: petalBreadth).path(in: rect)
            )
        }
        
        return path
    }
}

struct ShapePreviews: PreviewProvider {
    
    static var previews: some View {
        Propeller(petalCount: 5, petalBreadth: Angle(degrees: 20))
            .fill(Color.blue)
    }
}
