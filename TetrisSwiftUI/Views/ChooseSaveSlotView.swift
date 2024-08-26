//
//  ChooseSaveSlotView.swift
//  TetrisSwiftUI
//
//  Created by Adrian on 2024-08-22.
//

import Foundation
import SwiftUI

struct ChooseSaveSlotView: View {
    let slots: [GameSaveSlot]
    let onStartGame: (Int) -> Void
    
    var body: some View {
        VStack {
            ForEach(slots) { slot in
                Button(action: {
                    onStartGame(slot.slotNumber)
                }) {
                    Text(slot.slotNumber == 0 ? "Slot \(slot.slotNumber + 1) - Empty" : "Slot \(slot.slotNumber) - Level \(slot.gameState.totalLinesCleared / 10) Score: \(slot.gameState.score)")
                        .padding()
                        .background(Color.gray)
                        .cornerRadius(10)
                }
                .padding()
            }
        }
    }
}

struct LoadGameView: View {
    let slots: [GameSaveSlot]
    let onLoadGame: (Int) -> Void
    
    var body: some View {
        VStack {
            ForEach(slots) { slot in
                Button(action: {
                    onLoadGame(slot.slotNumber)
                }) {
                    Text("Slot \(slot.slotNumber + 1) - Level \(slot.gameState.totalLinesCleared / 10) Score: \(slot.gameState.score)")
                        .padding()
                        .background(Color.gray)
                        .cornerRadius(10)
                }
                .padding()
            }
            if slots.isEmpty {
                Text("No saves available")
                    .padding()
                    .background(Color.red)
                    .cornerRadius(10)
            }
        }
    }
}
