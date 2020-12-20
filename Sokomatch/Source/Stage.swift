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

enum StageEvent {
    case goal
}

class Stage: ObservableObject {
    
    @Published
    var board: Board?
    
    func setup(size: CGSize) {
        self.size = size
        
        advance()
    }
    
    func advance() {
        board = board(withSize: size)
        board?.populate()
        
        board?.onEvent.sink {
            [weak self] in
            switch $0 {
            case .goal:
                self?.advance()
            }
        }.store(in: &cancellables)
    }
    
    func reset() {
        board?.clear()
        board?.populate()
    }
    
    // MARK: Private
    
    private var size: CGSize = .zero
    
    private var cancellables = Set<AnyCancellable>()
    
    private func board(withSize size: CGSize) -> Board {
        let length = {
            Array(stride(from: 3, through: 7, by: 2)).randomElement()!
        }
        return Board(cols: length(), rows: length(), width: size.width)
    }
}

extension Board {
    
    func populate() {
        let types: [TokenType?] = [.water, nil, .fire, nil, .bomb, nil, .wall, nil, .target]
        
        place(token: Actor(location: center))
        place(token: Trigger(event: .goal, location: corners.randomElement()!))
        
        for y in 0..<rows {
            for x in 0..<cols {
                let location = Location(x: x, y: y)
                
                guard isAvailable(location: location), let randomType = types.randomElement()! else {
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
