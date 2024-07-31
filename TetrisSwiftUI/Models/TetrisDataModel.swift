//
//  TetrisDataModel.swift
//  TetrisSwiftUI
//
//  Created by Adrian on 2024-07-29.
//

import Foundation
import SwiftUI

struct TetrisPiece {
    enum Shape {
        case I, O, T, L, J, S, Z
    }

    enum Orientation {
        case north, south, east, west
    }

    let shape: Shape
    var orientation: Orientation
    let colour: Color
    
    init(shape: Shape, orientation: Orientation) {
        self.shape = shape
        self.orientation = orientation
        self.colour = TetrisPiece.shapeColors[shape] ?? .gray // Default to gray if not found
    }

    var cells: [(Int, Int)] {
        switch shape {
        case .I:
            switch orientation {
            case .north, .south:
                return [(0, 0), (1, 0), (2, 0), (3, 0)]
            case .east, .west:
                return [(0, 0), (0, 1), (0, 2), (0, 3)]
            }
        case .O:
            return [(0, 0), (0, 1), (1, 0), (1, 1)]
        case .T:
            switch orientation {
            case .north:
                return [(0, 1), (1, 0), (1, 1), (1, 2)]
            case .south:
                return [(0, 0), (0, 1), (0, 2), (1, 1)]
            case .east:
                return [(0, 1), (1, 1), (2, 1), (1, 0)]
            case .west:
                return [(0, 1), (1, 1), (2, 1), (1, 2)]
            }
        case .L:
            switch orientation {
            case .north:
                return [(0, 0), (1, 0), (2, 0), (2, 1)]
            case .south:
                return [(0, 0), (0, 1), (1, 1), (2, 1)]
            case .east:
                return [(0, 0), (0, 1), (0, 2), (1, 0)]
            case .west:
                return [(0, 2), (1, 0), (1, 1), (1, 2)]
            }
        case .J:
            switch orientation {
            case .north:
                return [(2, 0), (0, 1), (1, 1), (2, 1)]
            case .south:
                return [(0, 0), (1, 0), (2, 0), (0, 1)]
            case .east:
                return [(0, 0), (1, 0), (1, 1), (1, 2)]
            case .west:
                return [(0, 0), (0, 1), (0, 2), (1, 2)]
            }
        case .S:
            switch orientation {
            case .north, .south:
                return [(0, 1), (0, 2), (1, 0), (1, 1)]
            case .east, .west:
                return [(0, 0), (1, 0), (1, 1), (2, 1)]
            }
        case .Z:
            switch orientation {
            case .north, .south:
                return [(0, 0), (0, 1), (1, 1), (1, 2)]
            case .east, .west:
                return [(0, 1), (1, 0), (1, 1), (2, 0)]
            }
        }
    }
    
    static let shapeColors: [Shape: Color] = [
        .I: .cyan,
        .O: .yellow,
        .T: .pink,
        .L: .orange,
        .J: .blue,
        .S: .green,
        .Z: .red
    ]
    
    static let nextOrientation: [Orientation: Orientation] = [
        .north: .east,
        .east: .south,
        .south: .west,
        .west: .north,
    ]
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

enum TetrisConstants {
    static let height = 20 // Number of rows
    static let width = 10 // Number of columns
    static let staticPieceColour: Color = .purple
}
