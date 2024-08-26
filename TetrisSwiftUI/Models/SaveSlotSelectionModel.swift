//
//  SaveSlotSelectionModel.swift
//  TetrisSwiftUI
//
//  Created by Adrian on 2024-08-26.
//

import Foundation

class SaveSlotSelectionViewModel: ObservableObject {
    @Published var selectedSlot: Int? = nil

    var isOkButtonEnabled: Bool {
        selectedSlot != nil
    }

    func selectSlot(_ slot: Int) {
        selectedSlot = slot
    }
}
