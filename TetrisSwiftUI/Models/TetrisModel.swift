//
//  TetrisModel.swift
//  TetrisSwiftUI
//
//  Created by Adrian on 2024-07-29.
//

import Foundation
import SwiftUI

class TetrisModel: ObservableObject {
    @Published var grid: [[TetrisBlock]] =
        Array(repeating: Array(repeating: .empty, count: TetrisConstants.width), count: TetrisConstants.height)
    @Published var currentPiece: TetrisPiece = .init(shape: .I, orientation: .north)
    @Published var currentPiecePosition: (row: Int, col: Int) = (0, 0)
    @Published var score: Int = 0
    @Published var totalLinesCleared: Int = 0
    @Published var gameOver: Bool = false

    private var gameTimer: Timer?
    private var gameInterval: TimeInterval = 1.0
    private var tetrisStreak: Int = 0

    init() {
        startGame()
    }

    func startGame() {
        resetGame()
        startGameTimer()
    }

    func resetGame() {
        grid = Array(repeating: Array(repeating: .empty, count: TetrisConstants.width), count: TetrisConstants.height)
        score = 0
        gameOver = false
        spawnPiece()
    }

    func startGameTimer() {
        gameTimer = Timer.scheduledTimer(withTimeInterval: gameInterval, repeats: true) {
            [weak self] (_: Timer) in
            self?.gameLoop()
        }
    }

    func stopGameTimer() {
        gameTimer?.invalidate()
        gameTimer = nil
    }

    func gameLoop() {
        if !gameOver {
            movePieceDown()
        }
    }

    func adjustGameInterval() {
        let level = score / 10
        let A: Double = 0.95 // Initial interval minus the minimum interval
        let k: Double = 0.15 // Decay rate
        let C: Double = 0.05 // Minimum interval

        let newInterval = A * exp(-k * Double(level)) + C

        if newInterval != gameInterval {
            gameInterval = newInterval
            stopGameTimer()
            startGameTimer()
        }
    }

    func spawnPiece() {
        let shapes: [TetrisPiece.Shape] = [.I, .O, .T, .L, .J, .S, .Z]
        let randomShape = shapes.randomElement()!
        currentPiece = TetrisPiece(shape: randomShape, orientation: .north)
        currentPiecePosition = (0, (TetrisConstants.width / 2) - 1)
        if !isPieceValid(at: currentPiecePosition, piece: currentPiece) {
            gameOver = true
            stopGameTimer()
        } else {
            updateGrid()
        }
    }

    func updateGrid() {
        // Reset the grid to empty
        for row in 0..<TetrisConstants.height {
            for col in 0..<TetrisConstants.width {
                if case .filled(let color) = grid[row][col], color == currentPiece.colour {
                    grid[row][col] = .empty
                }
            }
        }

        for cell in currentPiece.cells {
            let row = currentPiecePosition.row + cell.0
            let col = currentPiecePosition.col + cell.1
            if row >= 0 && row < TetrisConstants.height && col >= 0 && col < TetrisConstants.width {
                grid[row][col] = .filled(currentPiece.colour)
            }
        }
    }

    func movePiece(_ direction: MoveDirection) {
        let newPosition = direction.transform(currentPiecePosition.row, currentPiecePosition.col)

        if isPieceValid(at: newPosition, piece: currentPiece) {
            currentPiecePosition = newPosition
            updateGrid()
        } else {
            // If moving down and it's not valid, it means the piece has landed
            if direction == .down {
                solidifyPiece()
                clearLines()
                spawnPiece()
            }
            print("Move invalid for piece at position: \(newPosition)")
        }
    }

    func movePieceDown() {
        movePiece(.down)
    }

    func movePieceLeft() {
        movePiece(.left)
    }

    func movePieceRight() {
        movePiece(.right)
    }

    func dropPiece() {
        while isPieceValid(at: (currentPiecePosition.row + 1, currentPiecePosition.col), piece: currentPiece) {
            currentPiecePosition.row += 1
        }
        updateGrid()
        solidifyPiece()
        spawnPiece()
    }

    func isPieceValid(at position: (Int, Int), piece: TetrisPiece) -> Bool {
        let pieceCells = piece.cells.map { (position.0 + $0.0, position.1 + $0.1) }
        for (row, col) in pieceCells {
            if row < 0 || row >= TetrisConstants.height || col < 0 || col >= TetrisConstants.width {
                print("Piece out of bounds at (\(row), \(col))")
                return false
            }
            if case .filled(let color) = grid[row][col], color == TetrisConstants.staticPieceColour {
                print("Piece collision at (\(row), \(col))")
                return false
            }
        }
        return true
    }

    func rotatePiece() {
        guard let newOrientation = TetrisPiece.nextOrientation[currentPiece.orientation] else {
            fatalError("Invalid orientation mapping for \(currentPiece.orientation)")
        }

        let newPiece = TetrisPiece(shape: currentPiece.shape, orientation: newOrientation)

        if isPieceValid(at: currentPiecePosition, piece: newPiece) {
            currentPiece = newPiece
        } else {
            // Attempt to push piece into valid position if it collides with wall
            let newPieceCells = newPiece.cells.map {
                (currentPiecePosition.row + $0.0, currentPiecePosition.col + $0.1)
            }
            let minCol = newPieceCells.min(by: { $0.1 < $1.1 })?.1 ?? 0
            let maxCol = newPieceCells.max(by: { $0.1 < $1.1 })?.1 ?? 0
            if minCol < 0 {
                let offset = -minCol
                let adjustedPieceCells = newPieceCells.map { ($0.0, $0.1 + offset) }
                if isPieceValid(at: (currentPiecePosition.row, currentPiecePosition.col + offset), piece: newPiece) {
                    currentPiecePosition.col += offset
                    currentPiece = newPiece
                } else {
                    print("Adjusted piece still invalid: \(adjustedPieceCells)")
                }
            } else if maxCol >= TetrisConstants.width {
                let offset = maxCol - TetrisConstants.width + 1
                let adjustedPieceCells = newPieceCells.map { ($0.0, $0.1 - offset) }
                if isPieceValid(at: (currentPiecePosition.row, currentPiecePosition.col - offset), piece: newPiece) {
                    currentPiecePosition.col -= offset
                    currentPiece = newPiece
                } else {
                    print("Adjusted piece still invalid: \(adjustedPieceCells)")
                }
            }
        }
        updateGrid()
    }

    func solidifyPiece() {
        // Change the current piece's color to indicate it is now static
        for cell in currentPiece.cells {
            let row = currentPiecePosition.row + cell.0
            let col = currentPiecePosition.col + cell.1
            if row >= 0 && row < TetrisConstants.height && col >= 0 && col < TetrisConstants.width {
                grid[row][col] = .filled(TetrisConstants.staticPieceColour)
            }
        }
        clearLines() // Call clearLines here
    }

    func clearLines() {
        var newGrid = grid.filter { row in
            !row.allSatisfy {
                if case .filled = $0 {
                    return true
                }
                return false
            }
        }

        // Add empty rows at the top of the grid
        let linesCleared = TetrisConstants.height - newGrid.count
        let scoreAdded = calculateScore(for: linesCleared)
        totalLinesCleared += linesCleared
        score += scoreAdded
        if linesCleared > 0 && linesCleared % 10 == 0 {
            adjustGameInterval()
        }
        let emptyRow = Array(repeating: TetrisBlock.empty, count: TetrisConstants.width)
        for _ in 0..<linesCleared {
            newGrid.insert(emptyRow, at: 0)
        }

        grid = newGrid
    }
    
    func calculateScore(for lines: Int)-> Int {
        switch lines {
        case 1:
            tetrisStreak = 0
            return 100
        case 2:
            tetrisStreak = 0
            return 300
        case 3:
            tetrisStreak = 0
            return 500
        case 4:
            tetrisStreak += 1
            return 800 + (tetrisStreak * 400)
        default:
            tetrisStreak = 0
            return 0
        }
    }

}
