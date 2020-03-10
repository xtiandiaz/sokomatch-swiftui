//
//  TokenBodyView.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 10.3.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import SwiftUI

struct TokenBodyView: View {
    
    private let style: TokenStyle
    
    init(style: TokenStyle) {
        self.style = style
    }
    
    var body: some View {
        Group {
            if style.shape == .roundedSquare {
                RoundedRectangle(cornerRadius: 5)
                    .fill(style.color)
            } else {
                Circle()
                    .fill(style.color)
            }
        }
    }
}

struct TokenBody_Previews: PreviewProvider {
    static var previews: some View {
        TokenBodyView(style: TokenStyle(color: .blue))
    }
}
