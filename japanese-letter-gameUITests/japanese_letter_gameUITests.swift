import XCTest

final class japanese_letter_gameUITests: XCTestCase {

    override func setUpWithError() throws {
        let app = XCUIApplication()
        app.launch()
        sleep(1)
        continueAfterFailure = false
    }

    func testViewSwitching() {
        /// Test each view can be swapped to without waiting.
        let app = XCUIApplication()
        
        app.buttons["Matching"].tap()
        // XCTAssertTrue(app.staticTexts["MatchingViewIdentifier"].exists)
        
        app.buttons["Tracing"].tap()
        XCTAssertTrue(app.staticTexts["TracingViewIdentifier"].exists)
        
        app.buttons["Pairing"].tap()
        XCTAssertTrue(app.otherElements["PairingViewIdentifier"].exists)
        
        app.buttons["Settings"].tap()
        XCTAssertTrue(app.otherElements["SettingsViewIdentifier"].exists)
    }

    func testCorrectAnswerUIUpdate() {
        let app = XCUIApplication()
        app.buttons["Matching"].tap()

        let correctButton = app.buttons["correctButton"]
        correctButton.tap()
        XCTAssertTrue(app.staticTexts["Correct!"].exists)
    }

    func testIncorrectAnswerUIUpdate() {
        let app = XCUIApplication()

        let allButtons = app.buttons.matching(identifier: "button")
        let correctButton = app.buttons["correctButton"]

        let incorrectButtons = allButtons.allElementsBoundByIndex.filter {
            $0.identifier != correctButton.identifier
        }
        let incorrectButton = incorrectButtons.first
        incorrectButton?.tap()
        XCTAssertFalse(app.staticTexts["Correct!"].exists)
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
