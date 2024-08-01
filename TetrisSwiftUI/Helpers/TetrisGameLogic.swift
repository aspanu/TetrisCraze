//
//  TetrisGameLogic.swift
//  TetrisSwiftUI
//
//  Created by Adrian on 2024-07-31.
//

// TetrisGameLogic.swift

import SwiftUI

struct TetrisGameLogic {
    
    static func spawnPiece(state: inout GameState) {
        if state.gameOver {
            return
        }
        let shapes: [TetrisPiece.Shape] = [.I, .O, .T, .L, .J, .S, .Z]
        let randomShape = shapes.randomElement()!
        let newPiece = TetrisPiece(shape: randomShape, orientation: .north)
        let newPosition = (0, (TetrisConstants.width / 2) - 1)
        if !isPieceValid(at: newPosition, piece: newPiece, state: state) {
            state.gameOver = true
        } else {
            state.currentPiece = newPiece
            state.currentPiecePosition = newPosition
            updateGrid(state: &state)
        }
    }
    
    static func updateGrid(state: inout GameState) {
        print("Updating the grid!")
        // Clear the grid
        for row in 0..<TetrisConstants.height {
            for col in 0..<TetrisConstants.width {
                if case .filled(let color) = state.grid[row][col], color == state.currentPiece.colour {
                    state.grid[row][col] = .empty
                }
            }
        }

        // Update the grid with the current piece's new position
        for cell in state.currentPiece.cells {
            let row = state.currentPiecePosition.row + cell.0
            let col = state.currentPiecePosition.col + cell.1
            if row >= 0 && row < TetrisConstants.height && col >= 0 && col < TetrisConstants.width {
                state.grid[row][col] = .filled(state.currentPiece.colour)
            }
        }
    }
    
    static func movePiece(_ direction: MoveDirection, state: inout GameState) {
        let newPosition = direction.transform(state.currentPiecePosition.row, state.currentPiecePosition.col)

        if isPieceValid(at: newPosition, piece: state.currentPiece, state: state) {
            state.currentPiecePosition = newPosition
            updateGrid(state: &state)
        } else {
            // If moving down and it's not valid, it means the piece has landed
            if direction == .down {
                solidifyPiece(state: &state)
                let linesCleared = clearLinesFromGrid(state: &state)
                if linesCleared > 0 {
                    GameLoopLogic.updateScoreAndInterval(linesCleared: linesCleared, state: &state)
                }
                spawnPiece(state: &state)
            }
        }
    }
    
    static func movePieceDown(state: inout GameState) {
        movePiece(.down, state: &state)
    }

    static func movePieceLeft(state: inout GameState) {
        print("Moving piece left")
        movePiece(.left, state: &state)
    }

    static func movePieceRight(state: inout GameState) {
        movePiece(.right, state: &state)
    }

    static func dropPiece(state: inout GameState) {
        while isPieceValid(at: (state.currentPiecePosition.row + 1, state.currentPiecePosition.col), piece: state.currentPiece, state: state) {
            state.currentPiecePosition.row += 1
        }
        updateGrid(state: &state)
        solidifyPiece(state: &state)
        let linesCleared = clearLinesFromGrid(state: &state)
        if linesCleared > 0 {
            GameLoopLogic.updateScoreAndInterval(linesCleared: linesCleared, state: &state)
        }
        spawnPiece(state: &state)
    }

    static func isPieceValid(at position: (Int, Int), piece: TetrisPiece, state: GameState) -> Bool {
        let pieceCells = piece.cells.map { (position.0 + $0.0, position.1 + $0.1) }
        for (row, col) in pieceCells {
            if row < 0 || row >= TetrisConstants.height || col < 0 || col >= TetrisConstants.width {
                return false
            }
            if case .filled(let color) = state.grid[row][col], color == TetrisConstants.staticPieceColour {
                return false
            }
        }
        return true
    }

    static func rotatePiece(state: inout GameState) {
        if (state.gameOver) {
            return
        }

        guard let newOrientation = TetrisPiece.nextOrientation[state.currentPiece.orientation] else {
            fatalError("Invalid orientation mapping for \(state.currentPiece.orientation)")
        }

        let newPiece = TetrisPiece(shape: state.currentPiece.shape, orientation: newOrientation)

        if isPieceValid(at: state.currentPiecePosition, piece: newPiece, state: state) {
            state.currentPiece = newPiece
        } else {
            // Attempt to push piece into valid position if it collides with wall
            let newPieceCells = newPiece.cells.map {
                (state.currentPiecePosition.row + $0.0, state.currentPiecePosition.col + $0.1)
            }
            let minCol = newPieceCells.min(by: { $0.1 < $1.1 })?.1 ?? 0
            let maxCol = newPieceCells.max(by: { $0.1 < $1.1 })?.1 ?? 0
            if minCol < 0 {
                let offset = -minCol
                let adjustedPieceCells = newPieceCells.map { ($0.0, $0.1 + offset) }
                if isPieceValid(at: (state.currentPiecePosition.row, state.currentPiecePosition.col + offset), piece: newPiece, state: state) {
                    state.currentPiecePosition.col += offset
                    state.currentPiece = newPiece
                } else {
                    print("Adjusted piece still invalid: \(adjustedPieceCells)")
                }
            } else if maxCol >= TetrisConstants.width {
                let offset = maxCol - TetrisConstants.width + 1
                let adjustedPieceCells = newPieceCells.map { ($0.0, $0.1 - offset) }
                if isPieceValid(at: (state.currentPiecePosition.row, state.currentPiecePosition.col - offset), piece: newPiece, state: state) {
                    state.currentPiecePosition.col -= offset
                    state.currentPiece = newPiece
                } else {
                    print("Adjusted piece still invalid: \(adjustedPieceCells)")
                }
            }
        }
        updateGrid(state: &state)
    }

    static func solidifyPiece(state: inout GameState) {
        // Change the current piece's color to indicate it is now static
        for cell in state.currentPiece.cells {
            let row = state.currentPiecePosition.row + cell.0
            let col = state.currentPiecePosition.col + cell.1
            if row >= 0 && row < TetrisConstants.height && col >= 0 && col < TetrisConstants.width {
                state.grid[row][col] = .filled(TetrisConstants.staticPieceColour)
            }
        }
    }

    static func clearLinesFromGrid(state: inout GameState) -> Int {
        var newGrid = state.grid.filter { row in
            !row.allSatisfy {
                if case .filled = $0 {
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

        state.grid = newGrid

        return linesCleared
    }
}
