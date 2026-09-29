import XCTest

final class NavigationUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments += ["-AppleLanguages", "(en)", "-AppleLocale", "en_US", "-NBlockerUITesting"]
        app.launch()
        assertScreen("screen.home")
    }

    func testNativeTabBarSwitchesEveryRootScreen() {
        selectTab("Sleep", screen: "screen.sleep")
        selectTab("Activity", screen: "screen.activity")
        selectTab("Protection", screen: "screen.protection")
        selectTab("Profile", screen: "screen.profile")
        selectTab("Home", screen: "screen.home")
    }

    func testHomeActionsSynchronizeNativeTabSelection() {
        let seeActivity = app.buttons["home.seeActivity"]
        XCTAssertTrue(seeActivity.waitForExistence(timeout: 5))
        seeActivity.tap()
        assertSelectedTab("Activity", screen: "screen.activity")

        selectTab("Home", screen: "screen.home")

        let focus = app.buttons["home.focus"]
        XCTAssertTrue(focus.waitForExistence(timeout: 5))
        focus.tap()
        assertSelectedTab("Protection", screen: "screen.protection")
    }

    func testPlatformCarouselSwipesAndOpensCenteredPlatform() {
        let carousel = app.scrollViews["home.platformCarousel"]
        XCTAssertTrue(carousel.waitForExistence(timeout: 5))

        let instagram = app.buttons["platform.instagram"]
        XCTAssertTrue(instagram.waitForExistence(timeout: 5))
        XCTAssertTrue(instagram.isHittable)
        instagram.tap()
        XCTAssertTrue(app.staticTexts["Applying your preferences"].waitForExistence(timeout: 2))
        XCTAssertTrue(element("browser.instagram").waitForExistence(timeout: 2))
        closeBrowser()

        carousel.swipeLeft()
        let youtube = app.buttons["platform.youtube"]
        XCTAssertTrue(youtube.waitForExistence(timeout: 5))
        XCTAssertTrue(waitForHittable(youtube, timeout: 5))
        youtube.tap()
        closeBrowser()
    }

    private func selectTab(_ title: String, screen identifier: String) {
        let tab = app.tabBars.buttons[title]
        XCTAssertTrue(tab.waitForExistence(timeout: 5), "Missing native \(title) tab")
        tab.tap()
        assertSelectedTab(title, screen: identifier)
    }

    private func assertSelectedTab(_ title: String, screen identifier: String) {
        let tab = app.tabBars.buttons[title]
        let selected = NSPredicate(format: "selected == true")
        let expectation = XCTNSPredicateExpectation(predicate: selected, object: tab)
        XCTAssertEqual(XCTWaiter.wait(for: [expectation], timeout: 5), .completed)
        assertScreen(identifier)
    }

    private func assertScreen(_ identifier: String) {
        let screen = element(identifier)
        XCTAssertTrue(screen.waitForExistence(timeout: 5), "Missing screen \(identifier)")
    }

    private func element(_ identifier: String) -> XCUIElement {
        app.descendants(matching: .any).matching(identifier: identifier).firstMatch
    }

    private func waitForHittable(_ element: XCUIElement, timeout: TimeInterval) -> Bool {
        let predicate = NSPredicate(format: "exists == true AND hittable == true")
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: element)
        return XCTWaiter.wait(for: [expectation], timeout: timeout) == .completed
    }

    private func closeBrowser() {
        let launchClose = app.buttons["Close browser"]
        if launchClose.waitForExistence(timeout: 1) {
            launchClose.tap()
        } else {
            let controls = app.buttons["Browser controls"]
            XCTAssertTrue(controls.waitForExistence(timeout: 8))
            controls.tap()
            let close = app.buttons["Close"]
            XCTAssertTrue(close.waitForExistence(timeout: 2))
            close.tap()
        }
        assertScreen("screen.home")
    }
}
