//
//  ScoreAndControlsView.swift
//  TetrisSwiftUI
//
//  Created by Adrian on 2024-08-26.
//

import Foundation
import SwiftUI

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

            HStack {
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
                
                Button(action: {
                    GameSaveManager.shared.saveGame()
                }) {
                    Image(systemName: "square.and.arrow.down.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }

                Button(action: {
                    endGame()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }

                
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding()
    }
    
    func endGame() {
        GameState.shared.reset()  // Resets the game state
        TetrisGame.shared.showStartScreen = true  // Return to the start screen
        // Additional logic for ending the game (like stopping timers, etc.)
    }
}

struct ScoreAndControlsView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreAndControlsView(
            score: 100,
            level: 5,
            isPaused: false,
            togglePauseAction: {}
        )
    }
}
