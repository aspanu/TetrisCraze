//
//  TetrisGameLoopTests.swift
//  TetrisSwiftUITests
//
//  Created by Adrian on 2024-08-01.
//

@testable import TetrisSwiftUI
import XCTest

class GameLoopTests: XCTestCase {
    override func setUpWithError() throws {
        GameState.shared.reset()
    }

    func testStartGameTimer() throws {
        GameLoop.startGameTimer()
        XCTAssertNotNil(GameState.shared.gameTimer, "Game timer should be initialized.")
    }

    func testStopGameTimer() throws {
        GameLoop.startGameTimer()
        GameLoop.stopGameTimer()
        XCTAssertNil(GameState.shared.gameTimer, "Game timer should be invalidated.")
    }

    func testGameLoopRuns() throws {
        let expectation = self.expectation(description: "Game loop should run")
        GameLoop.startGameTimer()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
        XCTAssertGreaterThanOrEqual(GameState.shared.currentPiecePosition.row, 1, "Piece should have moved down by at least one row.")
    }

    func testAdjustGameInterval() throws {
        GameState.shared.totalLinesCleared = 10
        GameLoop.adjustGameInterval()
        XCTAssertLessThan(GameState.shared.gameInterval, 1.0, "Game interval should decrease as the level increases.")
    }
}
