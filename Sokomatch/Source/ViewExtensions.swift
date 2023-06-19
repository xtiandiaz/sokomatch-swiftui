//
//  ViewExtensions.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 18.2.2021.
//  Copyright © 2021 Berilio. All rights reserved.
//

import SwiftUI

extension View {
    
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorners(radius: radius, corners: corners))
    }
    
    
}

struct RoundedCorners: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        Path(
            UIBezierPath(
                roundedRect: rect, byRoundingCorners: corners,
                cornerRadii: CGSize(width: radius, height: radius)
            ).cgPath
        )
    }
}
