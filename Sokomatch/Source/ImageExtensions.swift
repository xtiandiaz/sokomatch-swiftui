//
//  ImageExtensions.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 18.2.2021.
//  Copyright © 2021 Berilio. All rights reserved.
//

import SwiftUI

extension Image {
    
    func resizableToFit() -> some View {
        resizable().aspectRatio(contentMode: .fit)
    }
}
