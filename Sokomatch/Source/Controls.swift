//
//  Controls.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 18.2.2021.
//  Copyright © 2021 Berilio. All rights reserved.
//

import SwiftUI

struct IconButton: View {
    
    let icon: Image
    var iconColor: Color = .black
    var backgroundColor: Color = .white
    let onTapped: () -> Void
    
    var body: some View {
        Button(action: onTapped) {
            icon
                .resizable()
                .frame(width: .m, height: .m)
                .foregroundColor(iconColor)
                .padding(.s)
                .background(backgroundColor.cornerRadius(.m))
        }
    }
}
