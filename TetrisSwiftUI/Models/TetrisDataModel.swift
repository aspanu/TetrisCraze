//
//  TetrisPiece.swift
//  TetrisSwiftUI
//
//  Created by Adrian on 2024-07-29.
//

import Foundation
import SwiftUI

struct TetrisPiece {
    enum Shape {
        case line
        // Add other shapes here as needed
    }

    enum Orientation {
        case north, south, east, west
    }

    let shape: Shape
    var orientation: Orientation

    var cells: [(Int, Int)] {
        switch shape {
        case .line:
            switch orientation {
            case .north, .south:
                return [(0, 0), (1, 0), (2, 0), (3, 0)]
            case .east, .west:
                return [(0, 0), (0, 1), (0, 2), (0, 3)]
            }
        }
    }
}

enum MoveDirection {
    case down, left, right

    var transform: (Int, Int) -> (Int, Int) {
        switch self {
        case .down:
            return { ($0 + 1, $1) }
        case .left:
            return { ($0, $1 - 1) }
        case .right:
            return { ($0, $1 + 1) }
        }
    }
}

enum TetrisBlock: Identifiable, Equatable {
    case empty, filled(Color)

    var id: UUID {
        UUID()
    }

    static func == (lhs: TetrisBlock, rhs: TetrisBlock) -> Bool {
        switch (lhs, rhs) {
        case (.empty, .empty):
            return true
        case (.filled(let lhsColour), .filled(let rhsColour)):
            return lhsColour == rhsColour
        default:
            return false
        }
    }
}