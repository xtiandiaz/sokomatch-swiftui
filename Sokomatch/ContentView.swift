//
//  ContentView.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 15.2.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject
    var game: Game
    
    var body: some View {
        ZStack {
            GameView()
        }
        .frame(maxHeight: .infinity)
        .background(Color.black)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Game(inventory: Inventory()))
    }
}
