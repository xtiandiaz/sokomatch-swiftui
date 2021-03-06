//
//  Utils.swift
//  Sokomatch
//
//  Created by Cristian Díaz on 18.2.2021.
//  Copyright © 2021 Berilio. All rights reserved.
//

import UIKit

enum Direction: Int, CaseIterable {
    
    case up, left, down, right
    
    var opposite: Direction {
        switch self {
        case .up: return .down
        case .left: return .right
        case .down: return .up
        case .right: return .left
        }
    }
}

enum Edge: String, Codable {
    
    case top, left, bottom, right
    
    var facingDirection: Direction {
        switch self {
        case .top: return .down
        case .left: return .right
        case .bottom: return .up
        case .right: return .left
        }
    }
}

enum Corner: String, Codable {
    
    case topLeft, topRight, bottomRight, bottomLeft
}

struct Location: Equatable, Hashable {
    
    public static let zero = Location(x: 0, y: 0)
    
    public let edges: UIRectEdge
    public let corners: UIRectCorner
    
    public var x: Int
    public var y: Int
    
    public init(x: Int, y: Int, edges: UIRectEdge = [], corners: UIRectCorner = []) {
        self.x = x
        self.y = y
        self.edges = edges
        self.corners = corners
    }
    
    public mutating func shift(toward direction: Direction, by steps: Int = 1) {
        switch direction {
        case .up: self.y -= steps
        case .right: self.x += steps
        case .down: self.y += steps
        case .left: self.x -= steps
        }
    }
    
    public func shifted(toward direction: Direction, by steps: Int = 1) -> Location {
        switch direction {
        case .up: return Location(x: self.x, y: self.y - steps)
        case .right: return Location(x: self.x + steps, y: self.y)
        case .down: return Location(x: self.x, y: self.y + steps)
        case .left: return Location(x: self.x - steps, y: self.y)
        }
    }
    
    public func shifted(byX x: Int, y: Int) -> Location {
        Location(x: self.x + x, y: self.y + y)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
    
    static func ==(lhs: Location, rhs: Location) -> Bool {
        lhs.x == rhs.x && lhs.y == rhs.y
    }
}

// MARK: - Codable

extension UIRectEdge: Codable {}
extension UIRectCorner: Codable {}

extension Location: Codable {
    
    enum CodingKeys: String, CodingKey {
        case x, y, edges, corners
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        x = try container.decode(Int.self, forKey: .x)
        y = try container.decode(Int.self, forKey: .y)
        edges = try container.decode(UIRectEdge.self, forKey: .edges)
        corners = try container.decode(UIRectCorner.self, forKey: .corners)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(x, forKey: .x)
        try container.encode(y, forKey: .y)
        try container.encode(edges, forKey: .edges)
        try container.encode(corners, forKey: .corners)
    }
}
