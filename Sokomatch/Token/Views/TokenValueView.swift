//
//  TokenValueView.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 22.2.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import SwiftUI

struct TokenValueView: View {
    
    private var value: Int
    
    var body: some View {
        Text("\(value)")
            .font(.title)
    }
    
    init?(token: Token) {
        guard token is Combinable else {
            return nil
        }
        
        if token.value < 1 {
            return nil
        }
        
        self.value = token.value
    }
}

struct TokenValueView_Previews: PreviewProvider {
    static var previews: some View {
        TokenValueView(token: Water(location: Location.zero))
    }
}
