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
    @Published var currentPiece: TetrisPiece = .init(shape: .line, orientation: .north)
    @Published var currentPiecePosition: (row: Int, col: Int) = (0, 0)
    @Published var currentPieceColour: Color = TetrisConstants.activePieceColour
    @Published var score: Int = 0
    @Published var gameOver: Bool = false
    
    private var gameTimer: Timer?
    private var gameInterval: TimeInterval = 1.0

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
            [weak self] (timer: Timer) in
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
            adjustGameInterval()
        }
    }
    
    func adjustGameInterval() {
        gameInterval = max(0.1, 1.0 - Double(score) * 0.1)
        stopGameTimer()
        startGameTimer()
    }
    
    func spawnPiece() {
        currentPiece = TetrisPiece(shape: .line, orientation: .north)
        currentPiecePosition = (0, (TetrisConstants.width / 2) - 1)
        if !isPieceValid(at: currentPiecePosition, piece: currentPiece) {
            print("Piece is invalid")
            gameOver = true
            stopGameTimer()
        } else {
            print("Piece is")
            updateGrid()
        }
    }


    func updateGrid() {
        // Reset the grid to empty
        for row in 0..<TetrisConstants.height {
            for col in 0..<TetrisConstants.width {
                if case .filled(let color) = grid[row][col], color == TetrisConstants.activePieceColour {
                    grid[row][col] = .empty
                }
            }
        }

        for cell in currentPiece.cells {
            let row = currentPiecePosition.row + cell.0
            let col = currentPiecePosition.col + cell.1
            if row >= 0 && row < TetrisConstants.height && col >= 0 && col < TetrisConstants.width {
                grid[row][col] = .filled(currentPieceColour)
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
        print("Dropping piece")
        while isPieceValid(at: (currentPiecePosition.row + 1, currentPiecePosition.col), piece: currentPiece) {
            currentPiecePosition.row += 1
        }
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
            if case .filled(let color) = grid[row][col], color != TetrisConstants.activePieceColour {
                print("Piece collision at (\(row), \(col))")
                return false
            }
        }
        return true
    }

    func rotatePiece() {
        let newOrientation: TetrisPiece.Orientation
        switch currentPiece.orientation {
        case .north:
            newOrientation = .east
        case .east:
            newOrientation = .south
        case .south:
            newOrientation = .west
        case .west:
            newOrientation = .north
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
                if case .filled(_) = $0 {
                    return true
                }
                return false
            }
        }

        // Add empty rows at the top of the grid
        let linesCleared = TetrisConstants.height - newGrid.count
        score += linesCleared
        let emptyRow = Array(repeating: TetrisBlock.empty, count: TetrisConstants.width)
        for _ in 0..<linesCleared {
            newGrid.insert(emptyRow, at: 0)
        }
        
        grid = newGrid
    }
}
