//
//  TetrisDataModel.swift
//  TetrisSwiftUI
//
//  Created by Adrian on 2024-07-29.
//

import Foundation
import SwiftUI

struct TetrisPiece: Equatable, Codable {
    enum Shape: Codable {
        case I, O, T, L, J, S, Z
    }

    enum Orientation: Codable {
        case north, south, east, west
    }

    let shape: Shape
    var orientation: Orientation

    init(shape: Shape, orientation: Orientation) {
        self.shape = shape
        self.orientation = orientation
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
        .Z: .red,
    ]

    static let nextOrientation: [Orientation: Orientation] = [
        .north: .east,
        .east: .south,
        .south: .west,
        .west: .north,
    ]
    
    var gridRepresentation: [[TetrisBlock]] {
        let size = 4 // Assume max size for a piece is 4x4
        var grid = Array(repeating: Array(repeating: TetrisBlock.empty, count: size), count: size)

        for cell in self.cells {
            grid[cell.0][cell.1] = .filled(ColourScheme.pieceColours[self.shape]!)
        }

        return grid
    }
    
    static func == (lhs: TetrisPiece, rhs: TetrisPiece) -> Bool {
        return lhs.shape == rhs.shape
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

enum TetrisBlock: Identifiable, Equatable, Codable {
    case empty, staticBlock, filled(GradientInfo), outline

    var id: UUID {
        UUID()
    }
    
    enum CodingKeys: String, CodingKey {
        case type, gradientInfo
    }

    enum BlockType: String, Codable {
        case empty, staticBlock, filled, outline
    }

    static func == (lhs: TetrisBlock, rhs: TetrisBlock) -> Bool {
        switch (lhs, rhs) {
        case (.empty, .empty), (.staticBlock, .staticBlock), (.outline, .outline):
            return true
        case (.filled(_), .filled(_)):
            return false
        default:
            return false
        }
    }
        
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .empty:
            try container.encode(BlockType.empty, forKey: .type)
        case .staticBlock:
            try container.encode(BlockType.staticBlock, forKey: .type)
        case .filled(let gradientInfo):
            try container.encode(BlockType.filled, forKey: .type)
            try container.encode(gradientInfo, forKey: .gradientInfo)
        case .outline:
            try container.encode(BlockType.outline, forKey: .type)
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(BlockType.self, forKey: .type)
        
        switch type {
        case .empty:
            self = .empty
        case .staticBlock:
            self = .staticBlock
        case .filled:
            let gradientInfo = try container.decode(GradientInfo.self, forKey: .gradientInfo)
            self = .filled(gradientInfo)
        case .outline:
            self = .outline
        }
    }
        
    func toLinearGradient() -> LinearGradient? {
        if case .filled(let gradientInfo) = self {
            return gradientInfo.toLinearGradient()
        }
        return nil
    }
}

enum TetrisConstants {
    static let height = 20 // Number of rows
    static let width = 10 // Number of columns
}

struct GradientInfo: Codable {
    let startColor: Color
    let endColor: Color
    let startPoint: UnitPoint
    let endPoint: UnitPoint
    
    enum CodingKeys: String, CodingKey {
        case startColor, endColor, startPointX, startPointY, endPointX, endPointY
    }
    
    // Initialize from a Gradient and UnitPoints
    init(gradient: Gradient, startPoint: UnitPoint, endPoint: UnitPoint) {
        // Assuming the gradient has at least two colors
        self.startColor = gradient.stops.first?.color ?? .clear
        self.endColor = gradient.stops.last?.color ?? .clear
        self.startPoint = startPoint
        self.endPoint = endPoint
    }
    
    // This method converts the stored information into a LinearGradient
    func toLinearGradient() -> LinearGradient {
        return LinearGradient(gradient: Gradient(colors: [startColor, endColor]), startPoint: startPoint, endPoint: endPoint)
    }
    
    // Encode function
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(startColor.toHex(), forKey: .startColor)
        try container.encode(endColor.toHex(), forKey: .endColor)
        try container.encode(startPoint.x, forKey: .startPointX)
        try container.encode(startPoint.y, forKey: .startPointY)
        try container.encode(endPoint.x, forKey: .endPointX)
        try container.encode(endPoint.y, forKey: .endPointY)
    }

    // Decode function
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let startColorHex = try container.decode(String.self, forKey: .startColor)
        let endColorHex = try container.decode(String.self, forKey: .endColor)
        let startX = try container.decode(CGFloat.self, forKey: .startPointX)
        let startY = try container.decode(CGFloat.self, forKey: .startPointY)
        let endX = try container.decode(CGFloat.self, forKey: .endPointX)
        let endY = try container.decode(CGFloat.self, forKey: .endPointY)

        self.startColor = Color(hex: startColorHex)
        self.endColor = Color(hex: endColorHex)
        self.startPoint = UnitPoint(x: startX, y: startY)
        self.endPoint = UnitPoint(x: endX, y: endY)
    }
}

// Helper extensions for Color
extension Color {
    func toHex() -> String? {
        let nsColor = NSColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        nsColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        let r = Int(red * 255)
        let g = Int(green * 255)
        let b = Int(blue * 255)

        return String(format: "#%02X%02X%02X", r, g, b)
    }

    init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.currentIndex = hex.startIndex
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let red = Double((rgbValue & 0xff0000) >> 16) / 255.0
        let green = Double((rgbValue & 0xff00) >> 8) / 255.0
        let blue = Double(rgbValue & 0xff) / 255.0
        self.init(red: red, green: green, blue: blue)
    }
}

class GameState: ObservableObject, Codable {
    static var shared = GameState()

    @Published var grid: [[TetrisBlock]]
    @Published var currentPiece: TetrisPiece
    @Published var currentPiecePosition: (row: Int, col: Int)
    @Published var score: Int
    @Published var totalLinesCleared: Int
    @Published var gameInterval: TimeInterval
    @Published var gameTimer: Timer?
    @Published var gameOver: Bool
    @Published var savedPiece: TetrisPiece? = nil
    @Published var hasSwitched: Bool = false
    @Published var currentSaveSlot: Int?

    var tetrisStreak: Int
    
    enum CodingKeys: String, CodingKey {
        case score, totalLinesCleared, grid, currentPiece, currentPiecePosition, gameInterval, gameOver, savedPiece, hasSwitched, tetrisStreak, currentSaveSlot
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(score, forKey: .score)
        try container.encode(totalLinesCleared, forKey: .totalLinesCleared)
        try container.encode(grid, forKey: .grid)
        try container.encode(currentPiece, forKey: .currentPiece)
        try container.encode(currentPiecePosition.row, forKey: .currentPiecePosition)
        try container.encode(currentPiecePosition.col, forKey: .currentPiecePosition)
        try container.encode(gameInterval, forKey: .gameInterval)
        try container.encode(gameOver, forKey: .gameOver)
        try container.encode(savedPiece, forKey: .savedPiece)
        try container.encode(hasSwitched, forKey: .hasSwitched)
        try container.encode(tetrisStreak, forKey: .tetrisStreak)
        try container.encode(currentSaveSlot, forKey: .currentSaveSlot)
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        score = try container.decode(Int.self, forKey: .score)
        totalLinesCleared = try container.decode(Int.self, forKey: .totalLinesCleared)
        grid = try container.decode([[TetrisBlock]].self, forKey: .grid)
        currentPiece = try container.decode(TetrisPiece.self, forKey: .currentPiece)
        let row = try container.decode(Int.self, forKey: .currentPiecePosition)
        let col = try container.decode(Int.self, forKey: .currentPiecePosition)
        currentPiecePosition = (row, col)
        gameInterval = try container.decode(TimeInterval.self, forKey: .gameInterval)
        gameOver = try container.decode(Bool.self, forKey: .gameOver)
        savedPiece = try container.decode(TetrisPiece?.self, forKey: .savedPiece)
        hasSwitched = try container.decode(Bool.self, forKey: .hasSwitched)
        tetrisStreak = try container.decode(Int.self, forKey: .tetrisStreak)
        currentSaveSlot = try container.decode(Int?.self, forKey: .currentSaveSlot)
    }
    
    private init() {
        grid = Array(repeating: Array(repeating: .empty, count: TetrisConstants.width), count: TetrisConstants.height)
        currentPiece = TetrisPiece(shape: .I, orientation: .north)
        currentPiecePosition = (0, (TetrisConstants.width / 2) - 1)
        score = 0
        totalLinesCleared = 0
        gameInterval = 1.0
        gameTimer = nil
        gameOver = false
        tetrisStreak = 0
    }

    func reset() {
        grid = Array(repeating: Array(repeating: .empty, count: TetrisConstants.width), count: TetrisConstants.height)
        currentPiece = TetrisPiece(shape: .I, orientation: .north)
        currentPiecePosition = (0, (TetrisConstants.width / 2) - 1)
        score = 0
        totalLinesCleared = 0
        gameInterval = 1.0
        gameTimer = nil
        gameOver = false
        tetrisStreak = 0
    }
    
    static func save(to slotNumber: Int) -> GameSaveSlot {
        return GameSaveSlot(id: slotNumber, gameState: shared)
    }

    static func load(from saveSlot: GameSaveSlot) {
        // Replace the current game state with the loaded one
        shared.grid = saveSlot.gameState.grid
        shared.currentPiece = saveSlot.gameState.currentPiece
        shared.currentPiecePosition = saveSlot.gameState.currentPiecePosition
        shared.score = saveSlot.gameState.score
        shared.totalLinesCleared = saveSlot.gameState.totalLinesCleared
        shared.gameInterval = saveSlot.gameState.gameInterval
        shared.gameTimer = saveSlot.gameState.gameTimer
        shared.gameOver = saveSlot.gameState.gameOver
        shared.savedPiece = saveSlot.gameState.savedPiece
        shared.hasSwitched = saveSlot.gameState.hasSwitched
        shared.currentSaveSlot = saveSlot.id
        shared.tetrisStreak = saveSlot.gameState.tetrisStreak
    }
}

struct GameSaveSlot: Codable, Identifiable {
    let id: Int
    let saveDate: Date
    var gameState: GameState

    // Other properties, like a thumbnail or description, can be added here
    
    init(id: Int, gameState: GameState, saveDate: Date = Date()) {
        self.id = id
        self.saveDate = saveDate
        self.gameState = gameState
    }
    
    static func load(from fileURL: URL) throws -> GameSaveSlot {
        let data = try Data(contentsOf: fileURL)
        return try JSONDecoder().decode(GameSaveSlot.self, from: data)
    }
    
    func save(to fileURL: URL) throws {
        let data = try JSONEncoder().encode(self)
        try data.write(to: fileURL)
    }
}
