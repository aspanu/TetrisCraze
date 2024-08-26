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

    func startNewGame(using slotNumber: Int) {
        showStartScreen = false
        
        // Reset the game state for a new game
        GameState.shared.reset()
        GameState.shared.currentSaveSlot = slotNumber 
        GameLoop.startGameTimer()
        TetrisGameLogic.spawnPiece()

    }

    func loadGame(from slotNumber: Int) {
        do {
            try GameSaveManager.shared.loadGameState(from: slotNumber)
            state = GameState.shared
            selectedSaveSlot = GameSaveManager.shared.saveSlots.first { $0.id == slotNumber }
            showStartScreen = false
            
            // Resume the game timer with the loaded game interval
            GameLoop.startGameTimer()
        } catch {
            print("Failed to load game: \(error)")
        }
    }

    func saveCurrentGame() {
        guard let slotNumber = state.currentSaveSlot else {
            print("No save slot selected.")
            return
        }
        
        do {
            try GameSaveManager.shared.saveCurrentGame(to: slotNumber, gameState: state)
            print("Game saved to slot \(slotNumber).")
        } catch {
            print("Failed to save game: \(error)")
        }
    }
    
    func startGame() {
    }

    func togglePause() {
        if GameState.shared.gameTimer != nil {
            GameLoop.stopGameTimer()
        } else {
            GameLoop.startGameTimer()
        }
        objectWillChange.send()
    }
    
    func pauseAndSaveGame() {
        GameLoop.stopGameTimer()
        if let slot = GameState.shared.currentSaveSlot {
            GameSaveManager.shared.saveCurrentGame(to: slot)
        }
    }

    func handleKeyEvent(_ event: NSEvent) {
        inputHandler.handleKeyEvent(event)
    }
}
