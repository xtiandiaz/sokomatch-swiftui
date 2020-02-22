//
//  StageView.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 22.2.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import SwiftUI

struct StageView: View {
    
    @ObservedObject private var vm: ViewModel = ViewModel()
    
    var body: some View {
        BoardView(board: vm.board) { tileSize in
            ForEach(self.vm.ids, id: \.self) { id in
                TokenView(token: self.vm.token(fromId: id), size: tileSize, stepLength: tileSize)
            }
        }
        .gesture(DragGesture(minimumDistance: vm.board.tileSize / 3)
            .onEnded { value in
                let dir: Direction
                let deltaX = value.translation.width
                let deltaY = value.translation.height
                if abs(deltaX) > abs(deltaY) {
                    dir = deltaX > 0 ? .right : .left
                } else {
                    dir = deltaY > 0 ? .up : .down
                }
                withAnimation(.linear(duration: 0.1)) {
                    self.vm.move(
                        tokenAtLocation: Location(
                            x: Int(value.startLocation.x / self.vm.board.tileSize),
                            y: Int(value.startLocation.y / self.vm.board.tileSize)),
                        toward: dir)
                }
        })
        .onAppear {
            self.vm.place(token: Blob(location: Location.zero, style: .red))
            self.vm.place(token: Blob(location: self.vm.board.center, style: .blue))
            self.vm.place(token: Blob(location: Location(x: self.vm.board.cols - 1, y: self.vm.board.rows - 1), style: .green))
        }
    }
}

struct StageView_Previews: PreviewProvider {
    static var previews: some View {
        StageView()
    }
}

extension StageView {
    
    class ViewModel: ObservableObject {
        
        let stage: Stage
        let board: Board
        
        @Published private(set) var _targets = [Location: UUID]()
        @Published private(set) var _tokens = [UUID: Token]()
        
        var ids: [UUID] {
            _tokens.values.map { $0.id }
        }
        
        init() {
            stage = Stage()
            board = stage.board
        }
        
        func place(token: Token) {
            _tokens[token.id] = token
            _targets[token.location] = token.id
        }
        
        func move(tokenAtLocation location: Location, toward direction: Direction) {
            if !board.isValid(location: location) {
                return
            }

            guard
                let tokenId = _targets[location],
                var token = _tokens[tokenId]
            else { return }
            
            if !token.canMove {
                print("Token can't be moved")
                return
            }
            
            let destination = board.nextLocation(from: location, toward: direction) {
                [weak self] in
                return self?._targets[$0] == nil
            }
            if destination == location {
                return
            }
            
            // Mutates the struct, thus creating a new, updated instance
            token.location = destination
            
            _targets[location] = nil
            _targets[destination] = token.id
            _tokens[token.id] = token
        }
        
        func token(fromId id: UUID) -> Token {
            _tokens[id]!
        }
    }
}
