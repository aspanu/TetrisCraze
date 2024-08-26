//
//  SerializationTests.swift
//  TetrisSwiftUITests
//
//  Created by Adrian on 2024-08-26.
//

import Foundation
import XCTest
@testable import TetrisSwiftUI

class SerializationTests: XCTestCase {
    func testSerializationAndDeserialization() {
        // Set up initial game state
        GameState.shared.grid[0][0] = .staticBlock
        GameState.shared.currentPiece = TetrisPiece(shape: .T, orientation: .east)
        GameState.shared.currentPiecePosition = (5, 5)
        GameState.shared.score = 1000
        GameState.shared.totalLinesCleared = 10
        GameState.shared.savedPiece = TetrisPiece(shape: .L, orientation: .west)

        // Serialize the game state
        let serializableState = GameState.shared.toSerializableGameState()
        guard let data = try? JSONEncoder().encode(serializableState) else {
            XCTFail("Failed to encode game state")
            return
        }

        // Deserialize the game state
        guard let decodedState = try? JSONDecoder().decode(SerializableGameState.self, from: data) else {
            XCTFail("Failed to decode game state")
            return
        }

        // Load the deserialized state back into the game
        GameState.shared.fromSerializableGameState(decodedState)

        // Verify the deserialized state matches the original state
        XCTAssertEqual(GameState.shared.grid[0][0], .staticBlock)
        XCTAssertEqual(GameState.shared.currentPiece.shape, .T)
        XCTAssertEqual(GameState.shared.currentPiece.orientation, .east)
        XCTAssertEqual(GameState.shared.currentPiecePosition.row, 5)
        XCTAssertEqual(GameState.shared.currentPiecePosition.col, 5)
        XCTAssertEqual(GameState.shared.score, 1000)
        XCTAssertEqual(GameState.shared.totalLinesCleared, 10)
        XCTAssertEqual(GameState.shared.savedPiece?.shape, .L)
        XCTAssertEqual(GameState.shared.savedPiece?.orientation, .west)
    }
}
