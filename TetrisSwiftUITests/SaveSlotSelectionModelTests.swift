//
//  SaveSlotSelectionModelTests.swift
//  TetrisSwiftUITests
//
//  Created by Adrian on 2024-08-26.
//

import Foundation
import XCTest
@testable import TetrisSwiftUI

class SaveSlotSelectionViewModelTests: XCTestCase {

    func testInitialOkButtonDisabled() {
        let viewModel = SaveSlotSelectionViewModel()
        XCTAssertFalse(viewModel.isOkButtonEnabled, "OK button should be disabled initially.")
    }

    func testSlotSelectionEnablesOkButton() {
        let viewModel = SaveSlotSelectionViewModel()
        viewModel.selectSlot(1)
        XCTAssertTrue(viewModel.isOkButtonEnabled, "OK button should be enabled after a slot is selected.")
    }

    func testSlotSelectionUpdatesSelectedSlot() {
        let viewModel = SaveSlotSelectionViewModel()
        viewModel.selectSlot(2)
        XCTAssertEqual(viewModel.selectedSlot, 2, "Selected slot should be updated after selection.")
    }
}
