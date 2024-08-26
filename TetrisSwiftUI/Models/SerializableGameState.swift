//
//  SerializableGameState.swift
//  TetrisSwiftUI
//
//  Created by Adrian on 2024-08-26.
//

import Foundation

struct SerializableGameState: Codable {
    let grid: [[Bool]]
    let currentPiece: PieceState
    let savedPiece: PieceState?
    let score: Int
    let totalLinesCleared: Int

    struct PieceState: Codable {
        let shape: TetrisPiece.Shape
        let orientation: TetrisPiece.Orientation
        let position: Position
        
        struct Position: Codable {
            let row: Int
            let col: Int
        }
    }
}
