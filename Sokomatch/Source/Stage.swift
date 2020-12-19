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
    var board: Board?
    
    @Published
    var size: CGSize?
    
    var isReady: Bool {
        size != nil
    }
    
    init() {
        cancellable = $size
            .compactMap { $0 }
            .first()
            .sink {
                [unowned self] size in
                self.boards = (0..<10).map {
                    Board(id: $0, cols: Int.random(in: 4...7), rows: Int.random(in: 4...7), width: size.width)
                }
                reset()
            }
    }
    
    func reset() {
        bi += 1
        if bi >= boards.count {
            bi = 0
        }
        
        board = boards[bi]
        board?.clear()
        board?.populate()
    }
    
    // MARK: Private
    
    private var boards = [Board]()
    private var bi = 0
    
    private var cancellable: Cancellable?
}

extension Board {
    
    func populate() {
        let types: [TokenType?] = [.water, nil, .fire, nil, .bomb, nil, .wall, nil, .target]
        
        for y in 0..<rows {
            for x in 0..<cols {
                guard let randomType = types.randomElement()! else {
                    continue
                }
                place(token: randomType.create(withLocation: Location(x: x, y: y)))
            }
        }
    }
}

// MARK: - Templates

extension Stage {
    
    static let preview = Stage()
}
