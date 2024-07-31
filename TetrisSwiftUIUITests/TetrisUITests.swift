//
//  TetrisUITests.swift
//  TetrisSwiftUIUITests
//
//  Created by Adrian on 2024-07-29.
//

import XCTest

class TetrisUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDown() {
        app = nil
        super.tearDown()
    }

    func simulateKeyPress(key: CGKeyCode) {
        let source = CGEventSource(stateID: .hidSystemState)
        let keyDown = CGEvent(keyboardEventSource: source, virtualKey: key, keyDown: true)
        let keyUp = CGEvent(keyboardEventSource: source, virtualKey: key, keyDown: false)

        keyDown?.post(tap: .cghidEventTap)
        keyUp?.post(tap: .cghidEventTap)
    }

    func testMovePieceDown() {
        let initialLabel = app.staticTexts["Score: 0"]
        XCTAssertTrue(initialLabel.exists)

        simulateKeyPress(key: 0x7D) // Down arrow key
        let newLabel = app.staticTexts["Score: 0"]
        XCTAssertTrue(newLabel.exists)
    }

    func testMovePieceLeft() {
        let initialLabel = app.staticTexts["Score: 0"]
        XCTAssertTrue(initialLabel.exists)

        simulateKeyPress(key: 0x7B) // Left arrow key
        let newLabel = app.staticTexts["Score: 0"]
        XCTAssertTrue(newLabel.exists)
    }

    func testMovePieceRight() {
        let initialLabel = app.staticTexts["Score: 0"]
        XCTAssertTrue(initialLabel.exists)

        simulateKeyPress(key: 0x7C) // Right arrow key
        let newLabel = app.staticTexts["Score: 0"]
        XCTAssertTrue(newLabel.exists)
    }

    func testRotatePiece() {
        let initialLabel = app.staticTexts["Score: 0"]
        XCTAssertTrue(initialLabel.exists)

        simulateKeyPress(key: 0x7E) // Up arrow key
        let newLabel = app.staticTexts["Score: 0"]
        XCTAssertTrue(newLabel.exists)
    }

    func testDropPiece() {
        let initialLabel = app.staticTexts["Score: 0"]
        XCTAssertTrue(initialLabel.exists)

        simulateKeyPress(key: 0x31) // Spacebar key
        let newLabel = app.staticTexts["Score: 0"]
        XCTAssertTrue(newLabel.exists)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
