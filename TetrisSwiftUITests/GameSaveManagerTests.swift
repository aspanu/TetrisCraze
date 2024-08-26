//
//  GameSaveManagerTests.swift
//  TetrisSwiftUITests
//
//  Created by Adrian on 2024-08-22.
//

@testable import TetrisSwiftUI
import XCTest

class GameSaveManagerTests: XCTestCase {
    func testSaveAndLoadGame() throws {
        // Create a test game state
        var state = GameState.shared
        state.score = 1000
        
        // Save to slot 1
        GameSaveManager.saveGame(state: state, slot: 1)
        
        // Load from slot 1
        if let loadedState = GameSaveManager.loadGame(slot: 1) {
            XCTAssertEqual(loadedState.score, 1000, "Loaded game should have the correct score")
        } else {
            XCTFail("Failed to load the game")
        }
    }
}
