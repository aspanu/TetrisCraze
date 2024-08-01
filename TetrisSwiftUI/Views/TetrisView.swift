//
//  TetrisView.swift
//  TetrisSwiftUI
//
//  Created by Adrian on 2024-07-29.
//

import SwiftUI

struct TetrisView: View {
    @StateObject private var tetrisGame = TetrisGame.shared

    var body: some View {
        ZStack {
            if tetrisGame.showStartScreen {
                VStack {
                    Text("Tetris Game")
                        .font(.largeTitle)
                        .padding()

                    Button(action: tetrisGame.startGame) {
                        Text("Start Game")
                            .font(.title)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            } else {
                HStack {
                    VStack(spacing: 1) {
                        ForEach(0..<tetrisGame.state.grid.count, id: \.self) { row in
                            HStack(spacing: 1) {
                                ForEach(0..<tetrisGame.state.grid[row].count, id: \.self) { column in
                                    Rectangle()
                                        .fill(self.colour(for: tetrisGame.state.grid[row][column]))
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
                        Text("Score: \(tetrisGame.state.score)")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black.opacity(0.5))
                            .cornerRadius(10)

                        Button(action: tetrisGame.togglePause) {
                            Text("Pause")
                                .font(.title)
                                .padding()
                                .background(Color.orange)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }

                        Spacer()
                    }
                }
                .overlay(
                    KeyEventHandlingView { event in
                        tetrisGame.handleKeyEvent(event)
                    }
                    .frame(width: 0, height: 0)
                )
                
                if tetrisGame.state.gameOver {
                    VStack {
                        Text("Game Over")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(10)
                        
                        Button(action: tetrisGame.startGame) {
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
        }
        .background(Color.gray.edgesIgnoringSafeArea(.all))
    }

    private func colour(for block: TetrisBlock) -> Color {
        switch block {
        case .empty:
            return Color.gray.opacity(0.2)
        case .filled(let color):
            return color
        }
    }
}

struct TetrisView_Previews: PreviewProvider {
    static var previews: some View {
        TetrisView()
    }
}
