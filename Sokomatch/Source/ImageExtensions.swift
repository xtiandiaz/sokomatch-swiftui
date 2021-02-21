//
//  ImageExtensions.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 18.2.2021.
//  Copyright © 2021 Berilio. All rights reserved.
//

import SwiftUI

extension Image {
    
    func resizableToFit(aspectRatio: CGFloat? = nil) -> some View {
        resizable().aspectRatio(aspectRatio, contentMode: .fit)
    }
}
