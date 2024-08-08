//
//  TetrisGame.swift
//  TetrisSwiftUI
//
//  Created by Adrian on 2024-07-31.
//

import SwiftUI

class TetrisGame: ObservableObject {
    static let shared = TetrisGame()

    @Published var inputHandler: ExternalInputHandler
    @Published var showStartScreen = true
    
    @ObservedObject var gameState = GameState.shared

    private init() {
        inputHandler = ExternalInputHandler()
    }

    func startGame() {
        showStartScreen = false
        GameState.shared.reset()
        GameLoop.startGameTimer()
        TetrisGameLogic.spawnPiece()
    }

    func togglePause() {
        if GameState.shared.gameTimer != nil {
            GameLoop.stopGameTimer()
        } else {
            GameLoop.startGameTimer()
        }
        objectWillChange.send()
    }

    func handleKeyEvent(_ event: NSEvent) {
        inputHandler.handleKeyEvent(event)
    }
}
