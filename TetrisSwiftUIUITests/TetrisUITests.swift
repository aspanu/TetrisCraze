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

    func testMovePieceDown() {
        let initialLabel = app.staticTexts["Score: 0"]
        XCTAssertTrue(initialLabel.exists)

        app.keyboards.keys["ArrowDown"].tap()
        let newLabel = app.staticTexts["Score: 0"]
        XCTAssertTrue(newLabel.exists)
    }

    func testMovePieceLeft() {
        let initialLabel = app.staticTexts["Score: 0"]
        XCTAssertTrue(initialLabel.exists)

        app.keyboards.keys["ArrowLeft"].tap()
        let newLabel = app.staticTexts["Score: 0"]
        XCTAssertTrue(newLabel.exists)
    }

    func testMovePieceRight() {
        let initialLabel = app.staticTexts["Score: 0"]
        XCTAssertTrue(initialLabel.exists)

        app.keyboards.keys["ArrowRight"].tap()
        let newLabel = app.staticTexts["Score: 0"]
        XCTAssertTrue(newLabel.exists)
    }

    func testRotatePiece() {
        let initialLabel = app.staticTexts["Score: 0"]
        XCTAssertTrue(initialLabel.exists)

        app.keyboards.keys["ArrowUp"].tap()
        let newLabel = app.staticTexts["Score: 0"]
        XCTAssertTrue(newLabel.exists)
    }

    func testDropPiece() {
        let initialLabel = app.staticTexts["Score: 0"]
        XCTAssertTrue(initialLabel.exists)

        app.keyboards.keys[" "].tap()
        let newLabel = app.staticTexts["Score: 1"]
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
