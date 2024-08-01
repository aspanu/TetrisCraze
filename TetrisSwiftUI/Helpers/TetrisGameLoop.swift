//
//  TetrisGameLoop.swift
//  TetrisSwiftUI
//
//  Created by Adrian on 2024-07-31.
//

import Foundation
import SwiftUI

struct GameLoop {
    
    static func updateScoreAndInterval(linesCleared: Int) {
        let scoreAdded = calculateScore(for: linesCleared)
        GameState.shared.totalLinesCleared += linesCleared
        GameState.shared.score += scoreAdded
        if linesCleared > 0 && GameState.shared.totalLinesCleared % 10 == 0 {
            adjustGameInterval()
        }
    }

    static func calculateScore(for lines: Int) -> Int {
        switch lines {
        case 1:
            GameState.shared.tetrisStreak = 0
            return 100
        case 2:
            GameState.shared.tetrisStreak = 0
            return 300
        case 3:
            GameState.shared.tetrisStreak = 0
            return 500
        case 4:
            GameState.shared.tetrisStreak += 1
            return 800 + (GameState.shared.tetrisStreak * 400)
        default:
            GameState.shared.tetrisStreak = 0
            return 0
        }
    }

    static func adjustGameInterval() {
        let level = GameState.shared.totalLinesCleared / 10
        let A: Double = 0.95 // Initial interval minus the minimum interval
        let k: Double = 0.15 // Decay rate
        let C: Double = 0.05 // Minimum interval

        let newInterval = A * exp(-k * Double(level)) + C
        print("New interval is: \(newInterval)")
        GameState.shared.gameInterval = newInterval
        stopGameTimer()
        startGameTimer()
    }
    
    static func startGameTimer() {
        GameState.shared.gameTimer = Timer.scheduledTimer(withTimeInterval: GameState.shared.gameInterval, repeats: true) { _ in
            gameLoop()
        }
    }

    static func stopGameTimer() {
        GameState.shared.gameTimer?.invalidate()
        GameState.shared.gameTimer = nil
    }

    static func gameLoop() {
        if !GameState.shared.gameOver {
            TetrisGameLogic.movePieceDown()
        }
    }
}
