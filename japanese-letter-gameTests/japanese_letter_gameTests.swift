import XCTest
@testable import japanese_letter_game

final class japanese_letter_gameTests: XCTestCase {
    var userDefaults: UserDefaults!

    override func setUp() {
        super.setUp()
        userDefaults = UserDefaults(suiteName: "TestUserDefaults")
    }

    override func tearDown() {
        userDefaults.removePersistentDomain(forName: "TestUserDefaults")
        userDefaults = nil
        super.tearDown()
    }

    func testSaveAndLoadSetting() {
        let testKey = "TestKey"
        let testValue = true
        userDefaults.set(testValue, forKey: testKey)

        let loadedValue = userDefaults.bool(forKey: testKey)

        XCTAssertEqual(
            loadedValue, testValue, "Loaded value from UserDefaults should match saved value.")
    }
}
