//
//  Board.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 15.2.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import SwiftUI
import Combine

struct BoardView: View {
    
    @ObservedObject private var vm: ViewModel
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.yellow)
            
            ForEach(self.vm.tokenIds, id: \.self) { id in
                TokenView(
                    token: self.vm.token(fromId: id),
                    size: self.vm.tileSize,
                    stepLength: self.vm.tileSize)
            }
        }
        .frame(
            width: CGFloat(vm.board.cols) * vm.board.tileSize,
            height: CGFloat(vm.board.rows) * vm.board.tileSize)
    }
    
    init(board: Board) {
        vm = ViewModel(board: board)
    }
}

struct Board_Previews: PreviewProvider {
    static var previews: some View {
        BoardView(board: Board.example)
    }
}

extension BoardView {
    
    class ViewModel: ObservableObject {
        
        let tileSize: CGFloat
        
        @Published var board: Board
        
        var tokenIds: [UUID] {
            Array(board.tokens.keys)
        }
        
        private var boardCancellable: AnyCancellable?
        
        init(board: Board) {
            self.board = board
            tileSize = board.tileSize
            
            boardCancellable = board.objectWillChange.sink { _ in
                self.objectWillChange.send()
            }
        }
        
        func token(fromId id: UUID) -> Token? {
            board.tokens[id]
        }
        
        func move(tokenAtLocation location: Location, toward direction: Direction) {
            if !board.isValid(location: location) {
                return
            }

            guard var token = board.tokenLocations[location] else { return }
            
            if !token.canMove {
                print("Token can't be moved")
                return
            }
            
            board.move(tokenAtLocation: location, toward: direction)
        }
    }
}
