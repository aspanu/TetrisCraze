//
//  TetrisGameLogicTests.swift
//  TetrisSwiftUITests
//
//  Created by Adrian on 2024-08-01.
//

@testable import TetrisSwiftUI
import XCTest

class TetrisGameLogicTests: XCTestCase {
    override func setUpWithError() throws {
        GameState.shared.reset()
    }

    func testSpawnPiece() throws {
        TetrisGameLogic.spawnPiece()
        let piece = GameState.shared.currentPiece
        XCTAssert([.I, .O, .T, .L, .J, .S, .Z].contains(piece.shape), "A new piece should be spawned.")
        XCTAssert(!GameState.shared.gameOver, "The game should not be over after spawning a new piece.")
    }

    func testMovePieceDown() throws {
        TetrisGameLogic.spawnPiece()
        let initialPosition = GameState.shared.currentPiecePosition
        TetrisGameLogic.movePieceDown()
        let newPosition = GameState.shared.currentPiecePosition
        XCTAssertEqual(newPosition.row, initialPosition.row + 1, "Piece should move down by one row.")
    }

    func testMovePieceLeft() throws {
        TetrisGameLogic.spawnPiece()
        let initialPosition = GameState.shared.currentPiecePosition
        TetrisGameLogic.movePieceLeft()
        let newPosition = GameState.shared.currentPiecePosition
        XCTAssertEqual(newPosition.col, initialPosition.col - 1, "Piece should move left by one column.")
    }

    func testMovePieceRight() throws {
        TetrisGameLogic.spawnPiece()
        let initialPosition = GameState.shared.currentPiecePosition
        TetrisGameLogic.movePieceRight()
        let newPosition = GameState.shared.currentPiecePosition
        XCTAssertEqual(newPosition.col, initialPosition.col + 1, "Piece should move right by one column.")
    }

    func testRotatePiece() throws {
        TetrisGameLogic.spawnPiece()
        let initialOrientation = GameState.shared.currentPiece.orientation
        TetrisGameLogic.rotatePiece()
        let newOrientation = GameState.shared.currentPiece.orientation
        XCTAssertNotEqual(newOrientation, initialOrientation, "Piece should change orientation after rotation.")
    }

    func testDropPiece() throws {
        TetrisGameLogic.spawnPiece()
        let initialPosition = GameState.shared.currentPiecePosition
        TetrisGameLogic.dropPiece()
        XCTAssertEqual(GameState.shared.grid[TetrisConstants.height - 1][initialPosition.col], .staticBlock, "A piece should have been dropped in this column")
    }
    
    func testClearSingleLine() throws {
        // Set up the grid with a full line
        GameState.shared.grid[19] = Array(repeating: .staticBlock, count: TetrisConstants.width)
        GameState.shared.currentPiecePosition = (19, 0)
        TetrisGameLogic.solidifyPiece()
        TetrisGameLogic.clearLinesFromGrid()

        XCTAssertEqual(GameState.shared.grid[19], Array(repeating: .empty, count: TetrisConstants.width), "The line should be cleared.")
    }

    func testClearMultipleLines() throws {
        // Set up the grid with multiple full lines
        GameState.shared.grid[18] = Array(repeating: .staticBlock, count: TetrisConstants.width)
        GameState.shared.grid[19] = Array(repeating: .staticBlock, count: TetrisConstants.width)
        TetrisGameLogic.solidifyPiece()
        TetrisGameLogic.clearLinesFromGrid()

        XCTAssertEqual(GameState.shared.grid[19], Array(repeating: .empty, count: TetrisConstants.width), "The bottom line should be cleared.")
        XCTAssertEqual(GameState.shared.grid[18], Array(repeating: .empty, count: TetrisConstants.width), "The line above should also be cleared.")
    }
    
    func testGameOverCondition() throws {
        // Fill the top row
        GameState.shared.grid[0] = Array(repeating: .staticBlock, count: TetrisConstants.width)
        TetrisGameLogic.spawnPiece()
        XCTAssertTrue(GameState.shared.gameOver, "The game should be over when a new piece can't be spawned.")
    }
    
    func testSaveAndSwitchPiece() throws {
        TetrisGameLogic.spawnPiece()
        let initialPiece = GameState.shared.currentPiece
        TetrisGameLogic.saveOrSwitchPiece()
        XCTAssertEqual(GameState.shared.savedPiece, initialPiece, "The initial piece should be saved.")
        
        TetrisGameLogic.spawnPiece() // Spawn a new piece
        let newPiece = GameState.shared.currentPiece
        TetrisGameLogic.saveOrSwitchPiece()
        XCTAssertEqual(GameState.shared.currentPiece, initialPiece, "The initial piece should be switched back as the current piece.")
        XCTAssertEqual(GameState.shared.savedPiece, newPiece, "The new piece should be saved.")
    }
}
