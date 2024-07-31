//
//  TetrisModelTests.swift
//  TetrisSwiftUITests
//
//  Created by Adrian on 2024-07-29.
//

@testable import TetrisSwiftUI
import XCTest

class TetrisModelTests: XCTestCase {
    var model: TetrisModel!

    override func setUp() {
        super.setUp()
        model = TetrisModel()
    }

    override func tearDown() {
        model = nil
        super.tearDown()
    }

    func testInitialSetup() {
        XCTAssertEqual(model.score, 0)
        XCTAssertEqual(model.grid.count, TetrisConstants.height)
        XCTAssertEqual(model.grid[0].count, TetrisConstants.width)
    }

    func testMovePieceDown() {
        let initialPosition = model.currentPiecePosition
        model.movePieceDown()
        XCTAssertEqual(model.currentPiecePosition.row, initialPosition.row + 1)
    }

    func testMovePieceLeft() {
        let initialPosition = model.currentPiecePosition
        model.movePieceLeft()
        XCTAssertEqual(model.currentPiecePosition.col, initialPosition.col - 1)
    }

    func testMovePieceRight() {
        let initialPosition = model.currentPiecePosition
        model.movePieceRight()
        XCTAssertEqual(model.currentPiecePosition.col, initialPosition.col + 1)
    }

    func testRotatePiece() {
        let initialOrientation = model.currentPiece.orientation
        model.rotatePiece()
        XCTAssertNotEqual(model.currentPiece.orientation, initialOrientation)
    }

    func testClearLines() {
        // Set up a grid with a complete line
        model.grid[19] = Array(repeating: .filled(TetrisConstants.staticPieceColour), count: TetrisConstants.width)
        model.clearLines()
        XCTAssertEqual(model.grid[19], Array(repeating: .empty, count: TetrisConstants.width))
        XCTAssertEqual(model.score, 1)
    }
}
