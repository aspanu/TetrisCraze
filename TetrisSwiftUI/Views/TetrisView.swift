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
                        GameBoardView(grid: gameState.grid, colour: self.colour)
                            .frame(width: geometry.size.width * 0.6)
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
    
    private func colour(for block: TetrisBlock) -> LinearGradient {
        switch block {
        case .empty:
            return LinearGradient(gradient: Gradient(colors: [Color.gray.opacity(0.2), Color.gray.opacity(0.5)]), startPoint: .top, endPoint: .bottom)
        case .staticBlock:
            return LinearGradient(gradient: Gradient(colors: [TetrisConstants.staticPieceColour]), startPoint: .top, endPoint: .bottom)
        case .outline:
            return LinearGradient(gradient: Gradient(colors: [Color.clear]), startPoint: .top, endPoint: .bottom)
        case .filled(let gradient):
            return gradient
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
                            .overlay(block == .outline ? Rectangle().stroke(TetrisConstants.outlinePieceColour, lineWidth: 4) : nil)
                            .frame(width: 30, height: 30)
                            .border(Color.white.opacity(0.3), width: 0.5)
                            .cornerRadius(5)
                            .accessibilityIdentifier("grid_\(row)_\(column)")
                            .accessibilityLabel(block == .empty ? "empty" : "filled")
                    }
                }
            }
        }
        .background(Color.black.opacity(0.5))
        .border(Color.black, width: 1)
        .padding()
        .shadow(radius: 5)
    }
}

struct ScoreAndControlsView: View {
    let score: Int
    let level: Int
    let isPaused: Bool
    let togglePauseAction: () -> Void

    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            HStack {
                VStack {
                    Text("Score:")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(10)
                    
                    Text("\(score)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(10)
                        .frame(maxWidth: .infinity)
                }
                VStack {
                    Text("Level:")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(10)

                    Text("\(level)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(10)
                        .frame(maxWidth: .infinity)
                }
            }

            Button(action: togglePauseAction) {
                Image(systemName: isPaused ? "play.fill" : "pause.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding()
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
