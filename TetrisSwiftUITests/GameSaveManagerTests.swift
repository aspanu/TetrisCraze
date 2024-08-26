//
//  GameSaveManagerTests.swift
//  TetrisSwiftUITests
//
//  Created by Adrian on 2024-08-26.
//

import XCTest
@testable import TetrisSwiftUI

class GameStateManagerTests: XCTestCase {

    override func setUpWithError() throws {
        // Before each test, reset the game state and make sure the save directory is clean
        GameState.shared.reset()
        cleanSaveDirectory()
        GameSaveManager.shared.createSavesDirectoryIfNeeded()
    }

    override func tearDownWithError() throws {
        // After each test, clean up the save directory
        cleanSaveDirectory()
    }

    private func cleanSaveDirectory() {
        let fileManager = FileManager.default
        let savesDirectory = GameSaveManager.shared.savesDirectoryURL
        if fileManager.fileExists(atPath: savesDirectory.path) {
            try? fileManager.removeItem(at: savesDirectory)
        }
    }

    func testSaveGame() throws {
        // Set up a known game state
        GameState.shared.score = 100
        GameState.shared.currentPiece = TetrisPiece(shape: .I, orientation: .north)
        GameState.shared.currentPiecePosition = (row: 5, col: 5)
        GameState.shared.currentSaveSlot = 1

        // Save the game state
        GameSaveManager.shared.saveGame()

        // Check that the file exists
        let saveExists = GameSaveManager.shared.saveExists(slot: 1)
        XCTAssertTrue(saveExists, "Save file should exist after saving the game.")
    }

    func testLoadGame() throws {
        // Set up a known game state and save it
        GameState.shared.score = 200
        GameState.shared.currentPiece = TetrisPiece(shape: .O, orientation: .east)
        GameState.shared.currentPiecePosition = (row: 10, col: 3)
        GameState.shared.currentSaveSlot = 1
        GameSaveManager.shared.saveGame()

        // Reset the game state
        GameState.shared.reset()

        // Load the game state
        GameSaveManager.shared.loadGame(slot: 1)

        // Check that the loaded state matches the saved state
        XCTAssertEqual(GameState.shared.score, 200, "Loaded score should match saved score.")
        XCTAssertEqual(GameState.shared.currentPiece.shape, .O, "Loaded piece shape should match saved piece shape.")
        XCTAssertEqual(GameState.shared.currentPiecePosition.row, 10, "Loaded piece row should match saved piece row.")
        XCTAssertEqual(GameState.shared.currentPiecePosition.col, 3, "Loaded piece column should match saved piece column.")
    }

    func testListSaveSlots() throws {
        // Save multiple game states
        GameState.shared.score = 100
        GameState.shared.currentSaveSlot = 1
        GameSaveManager.shared.saveGame()
        
        GameState.shared.score = 200
        GameState.shared.currentSaveSlot = 2
        GameSaveManager.shared.saveGame()
        
        GameState.shared.score = 300
        GameState.shared.currentSaveSlot = 3
        GameSaveManager.shared.saveGame()

        // List the save slots
        let saveSlots = GameSaveManager.shared.listSaveSlots()

        // Check that all three save slots are listed
        XCTAssertEqual(saveSlots.count, 3, "There should be 3 save slots.")
        XCTAssertTrue(saveSlots.contains(1), "Save slot 1 should be listed.")
        XCTAssertTrue(saveSlots.contains(2), "Save slot 2 should be listed.")
        XCTAssertTrue(saveSlots.contains(3), "Save slot 3 should be listed.")
    }
}
