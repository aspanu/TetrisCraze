//
//  GameSaveManager.swift
//  TetrisSwiftUI
//
//  Created by Adrian on 2024-08-26.
//

import Foundation

class GameSaveManager {
    static let shared = GameSaveManager()
    private let fileManager = FileManager.default
    private let directoryName = "TetrisGameSaves"
    
    private init() {
        createSavesDirectoryIfNeeded()
    }
    
    var savesDirectoryURL: URL {
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentDirectory.appendingPathComponent(directoryName)
    }
    
    func createSavesDirectoryIfNeeded() {
        if !fileManager.fileExists(atPath: savesDirectoryURL.path) {
            do {
                try fileManager.createDirectory(at: savesDirectoryURL, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Error creating saves directory: \(error)")
            }
        }
    }
    
    func saveGame() {
        let slot = GameState.shared.currentSaveSlot
        let fileURL = savesDirectoryURL.appendingPathComponent("SaveSlot\(slot).json")
        
        do {
            let serializedState = GameState.shared.toSerializableGameState()
            let data = try JSONEncoder().encode(serializedState)
            try data.write(to: fileURL)
            print("Game saved successfully in slot \(slot).")
        } catch {
            print("Error saving game: \(error)")
        }
    }
    
    func loadGame(slot: Int) {
        let fileURL = savesDirectoryURL.appendingPathComponent("SaveSlot\(slot).json")
        
        do {
            let data = try Data(contentsOf: fileURL)
            let serializedState = try JSONDecoder().decode(SerializableGameState.self, from: data)
            GameState.shared.fromSerializableGameState(serializedState)
            print("Game loaded successfully from slot \(slot).")
        } catch {
            print("Error loading game: \(error)")
        }
    }
        
    func saveExists(slot: Int) -> Bool {
        let fileURL = savesDirectoryURL.appendingPathComponent("SaveSlot\(slot).json")
        return fileManager.fileExists(atPath: fileURL.path)
    }
    
    func listSaveSlots() -> [Int] {
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: savesDirectoryURL, includingPropertiesForKeys: nil)
            return fileURLs.compactMap { url -> Int? in
                let fileName = url.deletingPathExtension().lastPathComponent
                return Int(fileName.replacingOccurrences(of: "SaveSlot", with: ""))
            }
        } catch {
            print("Error listing save slots: \(error)")
            return []
        }
    }
}
