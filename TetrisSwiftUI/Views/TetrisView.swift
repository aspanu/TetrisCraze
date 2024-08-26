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
    
    @State private var currentLevel: Int = 0
    @State private var showLevelUp = false

    var body: some View {
        ZStack {
            ColourScheme.backgroundGradient
                            .edgesIgnoringSafeArea(.all) // Ensure the background gradient covers the entire screen
            
            if tetrisGame.showStartScreen {
                StartScreenView(startGameAction: tetrisGame.startGame)
            } else {
                GeometryReader { geometry in
                    HStack(spacing: 0) {
                        // Saved Piece Section (20% of the width)
                        SavedPieceView(savedPiece: gameState.savedPiece)
                            .frame(width: geometry.size.width * 0.15)
                            .padding()

                        GameBoardView(grid: gameState.grid, blockSize: 30)
                            .frame(width: geometry.size.width * 0.5)
                            .overlay(
                                ZStack {
                                    LevelUpView(showLevelUp: $showLevelUp, level: $currentLevel)
                                }
                            )
                            .onChange(
                                of: gameState.totalLinesCleared) { oldValue, newValue in
                                    let newLevel = newValue / 10
                                    let oldLevel = oldValue / 10
                                    
                                    if newLevel > oldLevel {
                                        currentLevel = newLevel
                                        showLevelUp = true
                                }
                            }

                        VStack(alignment: .trailing, spacing: 20, content: {
                            ScoreAndControlsView(
                                score: gameState.score,
                                level: gameState.totalLinesCleared / 10,
                                isPaused: gameState.gameTimer == nil,
                                togglePauseAction: tetrisGame.togglePause
                            )
                            
                            Spacer()
                            ControlGuideView()
                        })
                    }
                    .overlay(
                        KeyEventHandlingView { event in
                            tetrisGame.handleKeyEvent(event)
                        }
                            .frame(width: 0, height: 0)
                    )
                    
                    if gameState.gameOver {
                        GameOverView(restartGameAction: tetrisGame.startGame)
                    }
                }
            }
        }
    }
    
}

struct GameOverView: View {
    let restartGameAction: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("Game Over")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding()
                .background(Color.red.opacity(0.7))
                .cornerRadius(10)

            Button(action: restartGameAction) {
                Text("Restart")
                    .font(.title)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding()
        .background(Color.black.opacity(0.5))
        .cornerRadius(15)
    }
}

struct ControlGuideView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Controls")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)

            Text("← →: Move Left/Right")
                .font(.subheadline)
                .foregroundColor(.white)
            Text("↑: Rotate Piece")
                .font(.subheadline)
                .foregroundColor(.white)
            Text("↓: Move Down")
                .font(.subheadline)
                .foregroundColor(.white)
            Text("Space: Drop Piece")
                .font(.subheadline)
                .foregroundColor(.white)
            Text("P: Pause Game")
                .font(.subheadline)
                .foregroundColor(.white)
            Text("F: Save/Switch Piece")
                .font(.subheadline)
                .foregroundColor(.white)
        }
        .padding()
        .background(Color.black.opacity(0.7))
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding(.trailing, 20)
    }
}

struct TetrisView_Previews: PreviewProvider {
    static var previews: some View {
        TetrisView()
    }
}
