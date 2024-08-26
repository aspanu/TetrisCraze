//
//  StartScreenView.swift
//  TetrisSwiftUI
//
//  Created by Adrian on 2024-08-12.
//

import Foundation
import SwiftUI

struct StartScreenView: View {
    let startGameAction: () -> Void
    @State private var showSaveSlotSelection = false
    @State private var isLoadingGame = false

    var body: some View {
        VStack {
            Text("Tetris Game")
                .font(.system(size: 50, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .padding()
                .background(Color.black)
                .cornerRadius(15)
            Button(action: {
                showSaveSlotSelection = true
                isLoadingGame = false
            }) {
                Text("New Game")
                    .font(.title)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            Button(action: {
                showSaveSlotSelection = true
                isLoadingGame = true
            }) {
                Text("Load Game")
                    .font(.title)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
        }
        .padding()
        .buttonStyle(PlainButtonStyle())
        .background(Color.clear)
        .sheet(isPresented: $showSaveSlotSelection) {
            SaveSlotSelectionView(
                viewModel: SaveSlotSelectionViewModel(),
                toLoad: isLoadingGame,
                isPresented: $showSaveSlotSelection,
                onSlotSelected: { selectedSlot in
                    if isLoadingGame {
                        GameSaveManager.shared.loadGame(slot: selectedSlot)
                        startGameAction()
                    } else {
                        GameState.shared.currentSaveSlot = selectedSlot
                        startGameAction()
                    }
                }
            )
        }
    }
}

struct StartScreen_Preview: PreviewProvider {
    static var previews: some View {
        StartScreenView {
            return
        }
    }
}
