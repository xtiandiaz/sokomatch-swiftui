//
//  GameView.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 22.2.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import SwiftUI
import Combine

struct GameView: View {
    
    @ObservedObject private var vm = ViewModel()
    
    var body: some View {
        StageView(stage: vm.stage)
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}

extension GameView {
    
    class ViewModel: ObservableObject {
        
        let stage: Stage
        
        private let game = Game()
        
        init() {
            stage = game.stage
        }
    }
}
