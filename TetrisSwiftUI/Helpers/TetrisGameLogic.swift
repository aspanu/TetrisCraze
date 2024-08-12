//
//  TetrisGameLogic.swift
//  TetrisSwiftUI
//
//  Created by Adrian on 2024-07-31.
//

// TetrisGameLogic.swift

import SwiftUI

struct TetrisGameLogic {
    
    static func spawnPiece() {
        let shapes: [TetrisPiece.Shape] = [.I, .O, .T, .L, .J, .S, .Z]
        let randomShape = shapes.randomElement()!
        let newPiece = TetrisPiece(shape: randomShape, orientation: .north)
        let newPosition = (0, (TetrisConstants.width / 2) - 1)
        if !isPieceValid(at: newPosition, piece: newPiece) {
            GameState.shared.gameOver = true
        } else {
            GameState.shared.currentPiece = newPiece
            GameState.shared.currentPiecePosition = newPosition
            updateGrid()
        }
    }
    
    static func updateGrid() {
        // Clear the grid
        for row in 0..<TetrisConstants.height {
            for col in 0..<TetrisConstants.width {
                let block = GameState.shared.grid[row][col]
                
                // Use a switch statement for cleaner matching
                switch block {
                    case .filled, .outline:
                        GameState.shared.grid[row][col] = .empty
                    default:
                        break
                }
            }
        }
        
        // Show the outline
        let dropPosition = calculateDropPosition()
        for cell in GameState.shared.currentPiece.cells {
            let row = dropPosition.row + cell.0
            let col = dropPosition.col + cell.1
            if row >= 0 && row < TetrisConstants.height && col >= 0 && col < TetrisConstants.width {
                GameState.shared.grid[row][col] = .outline
            }
        }

        // Update the grid with the current piece's new position
        for cell in GameState.shared.currentPiece.cells {
            let row = GameState.shared.currentPiecePosition.row + cell.0
            let col = GameState.shared.currentPiecePosition.col + cell.1
            if row >= 0 && row < TetrisConstants.height && col >= 0 && col < TetrisConstants.width {
                GameState.shared.grid[row][col] = .filled(GameState.shared.currentPiece.colour)
            }
        }
    }
    
    static func movePiece(_ direction: MoveDirection) {
        let newPosition = direction.transform(GameState.shared.currentPiecePosition.row, GameState.shared.currentPiecePosition.col)

        if isPieceValid(at: newPosition, piece: GameState.shared.currentPiece) {
            GameState.shared.currentPiecePosition = newPosition
            updateGrid()
        } else {
            // If moving down and it's not valid, it means the piece has landed
            if direction == .down {
                solidifyPiece()
                let linesCleared = clearLinesFromGrid()
                if linesCleared > 0 {
                    GameLoop.updateScoreAndInterval(linesCleared: linesCleared)
                }
                spawnPiece()
            }
        }
    }
    
    static func movePieceDown() {
        movePiece(.down)
    }

    static func movePieceLeft() {
        movePiece(.left)
    }

    static func movePieceRight() {
        movePiece(.right)
    }
    
    static func calculateDropPosition() -> (row: Int, col: Int) {
        var dropPosition = GameState.shared.currentPiecePosition
        while isPieceValid(at: (dropPosition.row + 1, dropPosition.col), piece: GameState.shared.currentPiece) {
            dropPosition.row += 1
        }
        return dropPosition
    }

    static func dropPiece() {
        while isPieceValid(at: (GameState.shared.currentPiecePosition.row + 1, GameState.shared.currentPiecePosition.col), piece: GameState.shared.currentPiece) {
            GameState.shared.currentPiecePosition.row += 1
        }
        updateGrid()
        solidifyPiece()
        let linesCleared = clearLinesFromGrid()
        if linesCleared > 0 {
            GameLoop.updateScoreAndInterval(linesCleared: linesCleared)
        }
        spawnPiece()
    }

    static func isPieceValid(at position: (Int, Int), piece: TetrisPiece) -> Bool {
        let pieceCells = piece.cells.map { (position.0 + $0.0, position.1 + $0.1) }
        for (row, col) in pieceCells {
            if row < 0 || row >= TetrisConstants.height || col < 0 || col >= TetrisConstants.width {
                return false
            }
            if case .staticBlock = GameState.shared.grid[row][col] {
                return false
            }
        }
        return true
    }

    static func rotatePiece() {
        guard let newOrientation = TetrisPiece.nextOrientation[GameState.shared.currentPiece.orientation] else {
            fatalError("Invalid orientation mapping for \(GameState.shared.currentPiece.orientation)")
        }

        let newPiece = TetrisPiece(shape: GameState.shared.currentPiece.shape, orientation: newOrientation)

        if isPieceValid(at: GameState.shared.currentPiecePosition, piece: newPiece) {
            GameState.shared.currentPiece = newPiece
        } else {
            // Attempt to push piece into valid position if it collides with wall
            let newPieceCells = newPiece.cells.map {
                (GameState.shared.currentPiecePosition.row + $0.0, GameState.shared.currentPiecePosition.col + $0.1)
            }
            let minCol = newPieceCells.min(by: { $0.1 < $1.1 })?.1 ?? 0
            let maxCol = newPieceCells.max(by: { $0.1 < $1.1 })?.1 ?? 0
            if minCol < 0 {
                let offset = -minCol
                let adjustedPieceCells = newPieceCells.map { ($0.0, $0.1 + offset) }
                if isPieceValid(at: (GameState.shared.currentPiecePosition.row, GameState.shared.currentPiecePosition.col + offset), piece: newPiece) {
                    GameState.shared.currentPiecePosition.col += offset
                    GameState.shared.currentPiece = newPiece
                } else {
                    // TODO: Move this to a log
                    print("Adjusted piece still invalid: \(adjustedPieceCells)")
                }
            } else if maxCol >= TetrisConstants.width {
                let offset = maxCol - TetrisConstants.width + 1
                let adjustedPieceCells = newPieceCells.map { ($0.0, $0.1 - offset) }
                if isPieceValid(at: (GameState.shared.currentPiecePosition.row, GameState.shared.currentPiecePosition.col - offset), piece: newPiece) {
                    GameState.shared.currentPiecePosition.col -= offset
                    GameState.shared.currentPiece = newPiece
                } else {
                    // TODO: Move this to a log
                    print("Adjusted piece still invalid: \(adjustedPieceCells)")
                }
            }
        }
        updateGrid()
    }

    static func solidifyPiece() {
        // Change the current piece's color to indicate it is now static
        for cell in GameState.shared.currentPiece.cells {
            let row = GameState.shared.currentPiecePosition.row + cell.0
            let col = GameState.shared.currentPiecePosition.col + cell.1
            if row >= 0 && row < TetrisConstants.height && col >= 0 && col < TetrisConstants.width {
                GameState.shared.grid[row][col] = .staticBlock
            }
        }
    }

    static func clearLinesFromGrid() -> Int {
        var newGrid = GameState.shared.grid.filter { row in
            !row.allSatisfy {
                if case .staticBlock = $0 {
                    return true
                }
                return false
            }
        }

        // Add empty rows at the top of the grid
        let linesCleared = TetrisConstants.height - newGrid.count
        let emptyRow = Array(repeating: TetrisBlock.empty, count: TetrisConstants.width)
        for _ in 0..<linesCleared {
            newGrid.insert(emptyRow, at: 0)
        }

        GameState.shared.grid = newGrid

        return linesCleared
    }
}
