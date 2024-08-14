//
//  ExternalInputHandler.swift
//  TetrisSwiftUI
//
//  Created by Adrian on 2024-07-31.
//

import SwiftUI

class ExternalInputHandler {
    func handleKeyEvent(_ event: NSEvent) {
        if GameState.shared.gameOver {
            // Handle game over
            return
        }
        switch event.keyCode {
        case 123:
            // Left arrow
            TetrisGameLogic.movePieceLeft()
        case 124:
            // Right arrow
            TetrisGameLogic.movePieceRight()
        case 125:
            // Down arrow
            TetrisGameLogic.movePieceDown()
        case 126:
            // Up arrow
            TetrisGameLogic.rotatePiece()
        case 49:
            // Spacebar
            TetrisGameLogic.dropPiece()
        case 35:
            // 'P' key for pause
            TetrisGame.shared.togglePause()
        case 3: // Key 'f'
            TetrisGameLogic.saveOrSwitchPiece()
        default:
            break
        }
    }
}
