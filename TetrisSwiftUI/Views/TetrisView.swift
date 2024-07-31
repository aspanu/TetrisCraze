//
//  TetrisView.swift
//  TetrisSwiftUI
//
//  Created by Adrian on 2024-07-29.
//

import SwiftUI

struct TetrisView: View {
    @ObservedObject var model = TetrisModel()

    var body: some View {
        HStack {
            VStack(spacing: 1) {
                ForEach(0..<model.grid.count, id: \.self) { row in
                    HStack(spacing: 1) {
                        ForEach(0..<model.grid[row].count, id: \.self) { column in
                            Rectangle()
                                .fill(self.colour(for: model.grid[row][column]))
                                .frame(width: 30, height: 30)
                                .border(Color.white.opacity(0.3), width: 0.5)
                        }
                    }
                }
            }
            .background(Color.black.opacity(0.5))
            .border(Color.black, width: 1)
            .padding()
            
            VStack {
                Text("Score: \(model.score)")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.5))
                    .cornerRadius(10)

                Spacer()
            }
        }
        .background(Color.gray.edgesIgnoringSafeArea(.all))
        .overlay(
            KeyEventHandlingView { event in
                self.handleKeyEvent(event)
            }
            .frame(width: 0, height: 0)
        )

        if model.gameOver {
            Text("Game Over")
                .font(.largeTitle)
                .padding()
            Button(action: {
                model.startGame()
            }) {
                Text("Restart Game")
                    .font(.title)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }

    private func colour(for block: TetrisBlock) -> Color {
        switch block {
        case .empty:
            return Color.gray.opacity(0.2)
        case .filled(let color):
            return color
        }
    }
    
    
    private func handleKeyEvent(_ event: NSEvent) {
        switch event.keyCode {
        case 123:
            // Left arrow
            model.movePieceLeft()
        case 124:
            // Right arrow
            model.movePieceRight()
        case 125:
            // Down arrow
            model.movePieceDown()
        case 126:
            // Up arrow
            model.rotatePiece()
        case 49:
            // Spacebar
            model.dropPiece()
        default:
            break
        }
    }
}

struct TetrisView_Previews: PreviewProvider {
    static var previews: some View {
        TetrisView()
    }
}
