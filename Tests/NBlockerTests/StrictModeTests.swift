import XCTest
@testable import NBlocker

final class StrictModeTests: XCTestCase {
    func testDelayBoundary() {
        let start = Date(timeIntervalSince1970: 1_000)
        let timing = StrictModeTiming(requestedAt: start, policy: .delayOneMinute, routineEndsAt: nil)
        XCTAssertFalse(timing.isAvailable(at: start.addingTimeInterval(59)))
        XCTAssertTrue(timing.isAvailable(at: start.addingTimeInterval(60)))
        XCTAssertEqual(timing.progress(at: start.addingTimeInterval(30)), 0.5, accuracy: 0.001)
    }

    func testUnavailablePolicyUsesRoutineEnd() {
        let start = Date(timeIntervalSince1970: 1_000)
        let end = start.addingTimeInterval(300)
        let timing = StrictModeTiming(requestedAt: start, policy: .unavailableUntilRoutineEnds, routineEndsAt: end)
        XCTAssertFalse(timing.isAvailable(at: end.addingTimeInterval(-1)))
        XCTAssertTrue(timing.isAvailable(at: end))
    }
}
