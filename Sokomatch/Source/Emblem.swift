//
//  Emblem.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 7.3.2021.
//  Copyright © 2021 Berilio. All rights reserved.
//

import SwiftUI

enum Emblem: String, CaseIterable, Codable {
    
    case triangle, diamond, circle
    
    var color: Color {
        switch self {
        case .triangle: return .orange
        case .diamond: return .green
        case .circle: return .blue
        }
    }
    
    static func random() -> Emblem {
        allCases.randomElement()!
    }
    
    func icon(withSize size: CGFloat) -> some View {
        Image(systemName: "\(rawValue)")
            .font(Font.system(size: size, weight: .black))
            .frame(width: size, height: size)
            .if(self == .triangle) { $0.offset(x: 0, y: -3) }
    }
}
