//
//  SavedPieceView.swift
//  TetrisSwiftUI
//
//  Created by Adrian on 2024-08-14.
//

import Foundation
import SwiftUI

struct SavedPieceView: View {
    let savedPiece: TetrisPiece?

    var body: some View {
        VStack {
            Text("Saved Piece")
                .font(.headline)
                .foregroundColor(.white)

            if let piece = savedPiece {
                GameBoardView(grid: piece.gridRepresentation,
                              blockSize: 20)
                    .frame(width: 100, height: 100)
            } else {
                Text("No Piece Saved")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .frame(width: 100, height: 100)
                    .border(Color.white, width: 2)
            }
        }
        .padding()
        .background(Color.black.opacity(0.7))
        .cornerRadius(10)
    }
}
