//
//  TetrisView.swift
//  TetrisSwiftUI
//
//  Created by Adrian on 2024-07-29.
//

import SwiftUI

struct TetrisView: View {
    @StateObject private var tetrisGame = TetrisGame.shared
    @ObservedObject private var gameState = GameState.shared
    
    var body: some View {
        ZStack {
            if tetrisGame.showStartScreen {
                StartScreenView(startGameAction: tetrisGame.startGame)
            } else {
                HStack {
                    GameBoardView(grid: GameState.shared.grid, colour: self.colour)

                    ScoreAndControlsView(
                        score: GameState.shared.score,
                        isPaused: GameState.shared.gameTimer == nil,
                        togglePauseAction: tetrisGame.togglePause
                    )
                }
                .overlay(
                    KeyEventHandlingView { event in
                        tetrisGame.handleKeyEvent(event)
                    }
                    .frame(width: 0, height: 0)
                )

                if GameState.shared.gameOver {
                    GameOverView(restartGameAction: tetrisGame.startGame)
                }
            }
        }
        .background(Color.gray.edgesIgnoringSafeArea(.all))
    }

    private func colour(for block: TetrisBlock) -> LinearGradient {
        switch block {
        case .empty:
            return LinearGradient(gradient: Gradient(colors: [Color.gray.opacity(0.2), Color.gray.opacity(0.5)]), startPoint: .top, endPoint: .bottom)
        case .staticBlock:
                return LinearGradient(gradient: Gradient(colors: [TetrisConstants.staticPieceColour]), startPoint: .top, endPoint: .bottom)
        case .filled(let gradient):
            return gradient
        }
    }
}



struct StartScreenView: View {
    let startGameAction: () -> Void

    var body: some View {
        VStack {
            Text("Tetris Game")
                .font(.largeTitle)
                .padding()

            Button(action: startGameAction) {
                Text("Start Game")
                    .font(.title)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }
}

struct GameBoardView: View {
    let grid: [[TetrisBlock]]
    let colour: (TetrisBlock) -> LinearGradient

    var body: some View {
        VStack(spacing: 1) {
            ForEach(0..<grid.count, id: \.self) { row in
                HStack(spacing: 1) {
                    ForEach(0..<grid[row].count, id: \.self) { column in
                        let block = grid[row][column]
                        Rectangle()
                            .fill(self.colour(block))
                            .frame(width: 30, height: 30)
                            .border(Color.white.opacity(0.3), width: 0.5)
                            .accessibilityIdentifier("grid_\(row)_\(column)")
                            .accessibilityLabel(block == .empty ? "empty" : "filled")
                    }
                }
            }
        }
        .background(Color.black.opacity(0.5))
        .border(Color.black, width: 1)
        .padding()
    }
}

struct ScoreAndControlsView: View {
    let score: Int
    let isPaused: Bool
    let togglePauseAction: () -> Void

    var body: some View {
        VStack {
            Text("Score: \(score)")
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding()
                .background(Color.black.opacity(0.5))
                .cornerRadius(10)

            Button(action: togglePauseAction) {
                Text(isPaused ? "Resume" : "Pause")
                    .font(.title)
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            Spacer()
        }
    }
}

struct GameOverView: View {
    let restartGameAction: () -> Void

    var body: some View {
        VStack {
            Text("Game Over")
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding()
                .background(Color.red)
                .cornerRadius(10)
            
            Button(action: restartGameAction) {
                Text("Restart")
                    .font(.title)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.black.opacity(0.75))
        .cornerRadius(10)
    }
}

struct TetrisView_Previews: PreviewProvider {
    static var previews: some View {
        TetrisView()
    }
}
