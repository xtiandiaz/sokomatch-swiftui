//
//  TokenType.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 8.3.2020.
//  Copyright © 2020 Berilio. All rights reserved.
//

struct TokenType: OptionSet {
    
    let rawValue: Int
    
    static let water = TokenType(rawValue: 1 << 0)
    static let fire = TokenType(rawValue: 1 << 1)
}
