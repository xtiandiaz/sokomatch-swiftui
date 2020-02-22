//
//  TokenValueView.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 22.2.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import SwiftUI

struct TokenValueView: View {
    
    private let value: Int
    
    var body: some View {
        Text("\(value)")
            .font(.title)
    }
    
    init?(token: Token) {
        guard let value = token.value else {
            return nil
        }
        
        self.value = value
    }
}

struct TokenValueView_Previews: PreviewProvider {
    static var previews: some View {
        TokenValueView(token: Blob.example)
    }
}
