//
//  ControlManager.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 28.2.2021.
//  Copyright © 2021 Berilio. All rights reserved.
//

import Combine
import SwiftUI

final class ControlManager {
    
    var unitSize: CGFloat = 20
    
    var onSwipe: AnyPublisher<Direction, Never> {
        swipeSubject.eraseToAnyPublisher()
    }
    
    var onDoubleTap: AnyPublisher<Void, Never> {
        doubleTapSubject.eraseToAnyPublisher()
    }
    
    private(set) lazy var swipeGesture = DragGesture(minimumDistance: unitSize / 2).onEnded {
        [weak self] in
        guard let self = self else {
            return
        }
        
        let dir: Direction
        let deltaX = $0.translation.width
        let deltaY = $0.translation.height

        if abs(deltaX) > abs(deltaY) {
            dir = deltaX > 0 ? .right : .left
        } else {
            dir = deltaY > 0 ? .down : .up
        }
        
        self.swipeSubject.send(dir)
    }
    
    private(set) lazy var doubleTapGesture = TapGesture(count: 2).onEnded {
        [weak self] in
        self?.doubleTapSubject.send()
    }
    
    // MARK: Private
    
    private let swipeSubject = PassthroughSubject<Direction, Never>()
    private let doubleTapSubject = PassthroughSubject<Void, Never>()
}
