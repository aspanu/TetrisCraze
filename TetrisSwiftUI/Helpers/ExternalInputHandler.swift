//
//  ExternalInputHandler.swift
//  TetrisSwiftUI
//
//  Created by Adrian on 2024-07-31.
//

import SwiftUI

class ExternalInputHandler {
    func handleKeyEvent(_ event: NSEvent, state: inout GameState) {
        switch event.keyCode {
        case 123:
            // Left arrow
            TetrisGameLogic.movePieceLeft(state: &state)
        case 124:
            // Right arrow
            TetrisGameLogic.movePieceRight(state: &state)
        case 125:
            // Down arrow
            TetrisGameLogic.movePieceDown(state: &state)
        case 126:
            // Up arrow
            TetrisGameLogic.rotatePiece(state: &state)
        case 49:
            // Spacebar
            TetrisGameLogic.dropPiece(state: &state)
        case 35:
            // 'P' key for pause
            TetrisGame.shared.togglePause()
        default:
            break
        }
    }
}
