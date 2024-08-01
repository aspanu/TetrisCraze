//
//  TetrisGameLoop.swift
//  TetrisSwiftUI
//
//  Created by Adrian on 2024-07-31.
//

// GameLoopLogic.swift

// GameLoopLogic.swift

import Foundation
import SwiftUI

struct GameLoopLogic {
    
    static func updateScoreAndInterval(linesCleared: Int, state: inout GameState) {
        let scoreAdded = calculateScore(for: linesCleared, state: &state)
        state.totalLinesCleared += linesCleared
        state.score += scoreAdded
        if linesCleared > 0 && state.totalLinesCleared % 10 == 0 {
            adjustGameInterval(state: &state)
        }
    }

    static func calculateScore(for lines: Int, state: inout GameState) -> Int {
        switch lines {
        case 1:
            state.tetrisStreak = 0
            return 100
        case 2:
            state.tetrisStreak = 0
            return 300
        case 3:
            state.tetrisStreak = 0
            return 500
        case 4:
            state.tetrisStreak += 1
            return 800 + (state.tetrisStreak * 400)
        default:
            state.tetrisStreak = 0
            return 0
        }
    }

    static func adjustGameInterval(state: inout GameState) {
        let level = state.totalLinesCleared / 10
        let A: Double = 0.95 // Initial interval minus the minimum interval
        let k: Double = 0.15 // Decay rate
        let C: Double = 0.05 // Minimum interval

        let newInterval = A * exp(-k * Double(level)) + C
        state.gameInterval = newInterval
    }
}
