//
//  TriggerLayer.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 9.2.2021.
//  Copyright © 2021 Berilio. All rights reserved.
//

import SwiftUI
import Combine
import Emerald

class TriggerLayer: BoardLayer<Trigger> {
    
    var onTriggered: AnyPublisher<Trigger, Never> {
        triggerSubject.eraseToAnyPublisher()
    }
    
    // MARK: Private
    
    private let triggerSubject = PassthroughSubject<Trigger, Never>()
}
