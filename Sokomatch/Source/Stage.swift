//
//  Stage.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 16.2.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

import SwiftUI
import Combine
import Emerald

class Stage: ObservableObject {
    
    @Published
    var board: Board
    
    init(boards: [Board]) {
        self.boards = boards
        
        board = boards[0]
    }
    
    func start() {
        cancellable = board.onReady
            .sink {
                print("completion \($0)")
            } receiveValue: {
                [unowned self] in
                self.start(board: $0)
            }
    }
    
    func reset() {
        board = boards[Int.random(in: 0..<boards.count)]
        
        board.clear()
        start()
    }
    
    // MARK: Private
    
    private let boards: [Board]
    
    private var cancellable: Cancellable?
    
    private func start(board: Board) {
        let types: [TokenType?] = [.water, nil, .fire, nil, .bomb, nil, .wall, nil, .target]
        
        for y in 0..<board.rows {
            for x in 0..<board.cols {
                guard let randomType = types.randomElement()! else {
                    continue
                }
                board.place(token: randomType.create(withLocation: Location(x: x, y: y)))
            }
        }
    }
}

// MARK: - Templates

extension Stage {
    
    static let preview = Stage(boards: [
        .init(id: 0, cols: 7, rows: 7)
    ])
}
