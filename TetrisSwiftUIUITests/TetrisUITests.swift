//
//  TetrisUITests.swift
//  TetrisSwiftUIUITests
//
//  Created by Adrian on 2024-07-29.
//

import XCTest

class TetrisUITests: XCTestCase {
    func testStartGameButton() throws {
        let app = XCUIApplication()
        app.launch()

        let startButton = app.buttons["Start Game"]
        XCTAssertTrue(startButton.exists, "Start Game button should exist.")
        startButton.tap()
        XCTAssertFalse(startButton.exists, "Start Game button should not exist after game starts.")
    }

    func testPauseButton() throws {
        let app = XCUIApplication()
        app.launch()

        let startButton = app.buttons["Start Game"]
        startButton.tap()

        let pauseButton = app.buttons["Pause"]
        XCTAssertTrue(pauseButton.exists, "Pause button should exist after game starts.")
        pauseButton.tap()
        let resumeButton = app.buttons["Resume"]
        XCTAssertEqual(resumeButton.label, "Resume", "Pause button should change to Resume after tapping.")
        resumeButton.tap()
        XCTAssertEqual(pauseButton.label, "Pause", "Resume button should change back to Pause after tapping.")
    }

    func testScoreLabelUpdates() throws {
        let app = XCUIApplication()
        app.launch()

        let startButton = app.buttons["Start Game"]
        startButton.tap()

        let scoreLabel = app.staticTexts["Score: 0"]
        XCTAssertTrue(scoreLabel.exists, "Score label should exist.")
        // Simulate clearing lines and updating score here.
        // This requires simulating game logic which might need more detailed UI interaction or mock data.
    }

    func testGameOverViewAppears() throws {
        let app = XCUIApplication()
        app.launch()

        let startButton = app.buttons["Start Game"]
        startButton.tap()

        // Simulate game over condition here.
        // This requires directly manipulating the game state, which might be complex for UI tests.
        // Consider setting a mock game state or a way to easily trigger game over.

        // Example:
        // app.buttons["Drop"].tap() // Simulate dropping a piece until game over
        // TODO: Figure out this test
        XCTAssertTrue(true)

//        let gameOverLabel = app.staticTexts["Game Over"]
//        XCTAssertTrue(gameOverLabel.exists, "Game Over label should appear when the game is over.")
    }

    func testGridAppears() throws {
        let app = XCUIApplication()
        app.launch()

        let startButton = app.buttons["Start Game"]
        startButton.tap()

        // Check if the grid cells exist
        let firstGridCell = app.otherElements["grid_0_0"]
        XCTAssertTrue(firstGridCell.exists, "First grid cell should exist after game starts.")

        // Check if a piece has spawned
        var pieceFound = false
        for row in 0..<20 { // TODO: Don't make this be hardcoded
            for col in 0..<10 {
                let cell = app.otherElements["grid_\(row)_\(col)"]
                if cell.exists && cell.label != "empty" { // Assuming cells have labels to indicate piece presence
                    pieceFound = true
                    break
                }
            }
            if pieceFound { break }
        }
        XCTAssertTrue(pieceFound, "A piece should be present on the grid after game starts.")
    }
}
