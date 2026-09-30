import XCTest
@testable import NBlocker

final class UsageTrackerTests: XCTestCase {
    @MainActor
    func testSessionDurationAndPreventedNavigation() {
        let suite = "UsageTrackerTests.\(UUID().uuidString)"
        guard let defaults = UserDefaults(suiteName: suite) else {
            return XCTFail("Could not create test defaults")
        }
        defer { defaults.removePersistentDomain(forName: suite) }
        let store = UsageStore(defaults: defaults)
        let tracker = UsageTracker(store: store)
        let start = Date(timeIntervalSince1970: 1_000)

        tracker.begin(platform: .instagram, at: start)
        tracker.recordPreventedNavigation()
        tracker.end(at: start.addingTimeInterval(125))

        let statistics = store.statistics(for: .instagram, on: start, asOf: start.addingTimeInterval(125))
        XCTAssertEqual(statistics.duration, 125, accuracy: 0.001)
        XCTAssertEqual(statistics.sessions, 1)
        XCTAssertEqual(statistics.preventedNavigations, 1)
    }

    @MainActor
    func testUsageTrackingContinuesWhenInstagramMetricsVisibilityChanges() throws {
        let suite = "UsageTrackerMetricsVisibilityTests.\(UUID().uuidString)"
        let defaults = try XCTUnwrap(UserDefaults(suiteName: suite))
        defer { defaults.removePersistentDomain(forName: suite) }
        let tracker = UsageTracker(store: UsageStore(defaults: defaults))
        let start = Date(timeIntervalSince1970: 2_000)
        let home = try XCTUnwrap(URL(string: "https://www.instagram.com/"))
        let inbox = try XCTUnwrap(URL(string: "https://www.instagram.com/direct/inbox/"))

        tracker.begin(platform: .instagram, at: start)
        let activeSessionID = try XCTUnwrap(tracker.activeSession?.id)

        XCTAssertTrue(BrowserMetricsVisibility.shouldShowInstagramHomeMetrics(
            platform: .instagram,
            presentation: .ready,
            currentURL: home,
            hasAuthenticatedInstagramShell: true
        ))
        XCTAssertFalse(BrowserMetricsVisibility.shouldShowInstagramHomeMetrics(
            platform: .instagram,
            presentation: .ready,
            currentURL: inbox,
            hasAuthenticatedInstagramShell: true
        ))
        XCTAssertEqual(tracker.activeSession?.id, activeSessionID)

        tracker.end(at: start.addingTimeInterval(125))
        XCTAssertEqual(
            UsageStore(defaults: defaults).statistics(
                for: .instagram,
                on: start,
                asOf: start.addingTimeInterval(125)
            ).duration,
            125,
            accuracy: 0.001
        )
    }

    func testUsageSessionDecodesMissingCounters() throws {
        let id = UUID()
        let startedAt = Date(timeIntervalSinceReferenceDate: 1_000)
        let json = #"{"id":"\#(id.uuidString)","platform":"instagram","startedAt":\#(startedAt.timeIntervalSinceReferenceDate)}"#
        let session = try JSONDecoder().decode(UsageSession.self, from: Data(json.utf8))

        XCTAssertEqual(session.id, id)
        XCTAssertEqual(session.platform, .instagram)
        XCTAssertEqual(session.preventedNavigations, 0)
        XCTAssertEqual(session.remindersTriggered, 0)
    }

    @MainActor
    func testInterruptedSessionIsClosedWithoutInventingUsage() throws {
        let suite = "UsageTrackerTests.\(UUID().uuidString)"
        let defaults = try XCTUnwrap(UserDefaults(suiteName: suite))
        defer { defaults.removePersistentDomain(forName: suite) }
        let openSession = UsageSession(platform: .youtube, startedAt: Date(timeIntervalSince1970: 500))
        defaults.set(try JSONEncoder().encode([openSession]), forKey: DefaultsKeys.usageSessions)

        let store = UsageStore(defaults: defaults)
        let recovered = try XCTUnwrap(store.sessions.first)
        XCTAssertEqual(recovered.endedAt, recovered.startedAt)
        XCTAssertEqual(recovered.duration(), 0)

        let persisted = try XCTUnwrap(defaults.data(forKey: DefaultsKeys.usageSessions))
        let restored = try JSONDecoder().decode([UsageSession].self, from: persisted)
        XCTAssertEqual(restored.first?.endedAt, openSession.startedAt)
    }

    @MainActor
    func testSessionDurationIsSplitAcrossCalendarDays() throws {
        let suite = "UsageTrackerTests.\(UUID().uuidString)"
        let defaults = try XCTUnwrap(UserDefaults(suiteName: suite))
        defer { defaults.removePersistentDomain(forName: suite) }
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = try XCTUnwrap(TimeZone(secondsFromGMT: 0))
        let start = try XCTUnwrap(calendar.date(from: DateComponents(year: 2026, month: 9, day: 28, hour: 23, minute: 50)))
        let end = try XCTUnwrap(calendar.date(byAdding: .minute, value: 20, to: start))
        let store = UsageStore(defaults: defaults)
        store.upsert(UsageSession(platform: .instagram, startedAt: start, endedAt: end))

        XCTAssertEqual(store.statistics(on: start, calendar: calendar, asOf: end).duration, 600, accuracy: 0.001)
        XCTAssertEqual(store.statistics(on: end, calendar: calendar, asOf: end).duration, 600, accuracy: 0.001)
    }
}
