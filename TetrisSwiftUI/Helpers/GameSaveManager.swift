//
//  GameSaveManager.swift
//  TetrisSwiftUI
//
//  Created by Adrian on 2024-08-22.
//

import Foundation

class GameSaveManager {
    static let shared = GameSaveManager()
    private(set) var saveSlots: [GameSaveSlot] = []

    private init() {
        loadAllSaveSlots()
    }

    func loadAllSaveSlots() {
        saveSlots.removeAll()
        for slotNumber in 1...3 { // Assuming 3 slots
            do {
                let slot = try loadSaveSlot(slotNumber: slotNumber)
                saveSlots.append(slot)
            } catch {
                print("Error loading save slot \(slotNumber): \(error)")
            }
        }
    }

    func loadSaveSlot(slotNumber: Int) throws -> GameSaveSlot {
        let fileURL = getFileURL(for: slotNumber)
        return try GameSaveSlot.load(from: fileURL)
    }

    func saveCurrentGame(to slotNumber: Int) throws {
        let saveSlot = GameSaveSlot(id: slotNumber, gameState: GameState.shared)
        let fileURL = getFileURL(for: slotNumber)
        try saveSlot.save(to: fileURL)
        updateSaveSlot(saveSlot)
    }

    func updateSaveSlot(_ slot: GameSaveSlot) {
        if let index = saveSlots.firstIndex(where: { $0.id == slot.id }) {
            saveSlots[index] = slot
        } else {
            saveSlots.append(slot)
        }
    }

    func loadGameState(from slotNumber: Int) throws {
        let saveSlot = try loadSaveSlot(slotNumber: slotNumber)
        GameState.shared = saveSlot.gameState
    }

    private func getFileURL(for slotNumber: Int) -> URL {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsURL.appendingPathComponent("saveSlot_\(slotNumber).json")
    }
}
