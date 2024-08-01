//
//  TetrisGameLogicTests.swift
//  TetrisSwiftUITests
//
//  Created by Adrian on 2024-08-01.
//

import XCTest
@testable import TetrisSwiftUI

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
        XCTAssertEqual(GameState.shared.grid[TetrisConstants.height - 1][initialPosition.col], .filled(TetrisConstants.staticPieceColour), "A piece should have been dropped in this column")
    }
}
