//
//  TetrisGame.swift
//  TetrisSwiftUI
//
//  Created by Adrian on 2024-07-31.
//

import SwiftUI

class TetrisGame: ObservableObject {
    static let shared = TetrisGame()

    @Published var state: GameState
    @Published var inputHandler: ExternalInputHandler

    @Published var showStartScreen = true

    private init() {
        state = GameState()
        inputHandler = ExternalInputHandler()
    }

    func startGame() {
        showStartScreen = false
        state = GameState()
        startGameTimer()
        TetrisGameLogic.spawnPiece(state: &state)
    }

    func togglePause() {
        if state.gameTimer != nil {
            stopGameTimer()
        } else {
            startGameTimer()
        }
    }

    func handleKeyEvent(_ event: NSEvent) {
        inputHandler.handleKeyEvent(event, state: &state)
    }

    private func startGameTimer() {
        state.gameTimer = Timer.scheduledTimer(withTimeInterval: state.gameInterval, repeats: true) { [weak self] _ in
            self?.gameLoop()
        }
    }

    private func stopGameTimer() {
        state.gameTimer?.invalidate()
        state.gameTimer = nil
    }

    private func gameLoop() {
        if !state.gameOver {
            TetrisGameLogic.movePieceDown(state: &state)
        }
    }
}
