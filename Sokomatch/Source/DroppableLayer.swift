//
//  DropLayer.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 24.2.2021.
//  Copyright © 2021 Berilio. All rights reserved.
//

import SwiftUI
import Combine

class DroppableLayer: BoardLayer<Droppable> {
    
    var onEvent: AnyPublisher<BoardEvent, Never> {
        reactionSubject.eraseToAnyPublisher()
    }
    
    func place<T: Droppable>(_ droppable: T) -> T {
        objectWillChange.send()
        
        place(token: droppable)
        
        switch droppable {
        case let bomb as Bomb:
            bomb.$isDetonated.sink {
                [weak self, weak bomb = bomb] in
                if $0, let bomb = bomb {
                    self?.remove(token: bomb)
                }
            }.store(in: &cancellables)
        default:
            break
        }
        
        return droppable
    }
    
    override func remove(token: Droppable) {
        super.remove(token: token)
        
        switch token.type {
        case .bomb: reactionSubject.send(.explosion(at: token.location))
        }
    }
    
    // MARK: Private
    
    private let reactionSubject = PassthroughSubject<BoardEvent, Never>()
    
    private var cancellables = Set<AnyCancellable>()
}

struct DroppableLayerView: BoardLayerView {
    
    @ObservedObject
    var layer: DroppableLayer
    
    let unitSize: CGFloat
    
    var body: some View {
        ForEach(layer.tokens) {
            token in
            Group {
                switch token {
                case let bomb as Bomb:
                    BombView(bomb: bomb)
                default:
                    EmptyView()
                }
            }
            .frame(width: unitSize, height: unitSize)
            .position(position(for: token.location))
        }
    }
}
