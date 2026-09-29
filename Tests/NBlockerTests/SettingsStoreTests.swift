import XCTest
@testable import NBlocker

final class SettingsStoreTests: XCTestCase {
    @MainActor
    func testSettingsRoundTrip() {
        let suite = "SettingsStoreTests.\(UUID().uuidString)"
        guard let defaults = UserDefaults(suiteName: suite) else {
            return XCTFail("Could not create test defaults")
        }
        defer { defaults.removePersistentDomain(forName: suite) }

        let store = SettingsStore(defaults: defaults)
        store.updateInstagram { $0.blockReelRoutes = false }
        store.updateYouTube { $0.hideShortsShelves = false }

        let restored = SettingsStore(defaults: defaults)
        XCTAssertFalse(restored.values.instagram.blockReelRoutes)
        XCTAssertFalse(restored.values.youtube.hideShortsShelves)
    }

    @MainActor
    func testCorruptSettingsFallBackToDefaults() {
        let suite = "SettingsStoreTests.\(UUID().uuidString)"
        guard let defaults = UserDefaults(suiteName: suite) else {
            return XCTFail("Could not create test defaults")
        }
        defer { defaults.removePersistentDomain(forName: suite) }
        defaults.set(Data("not-json".utf8), forKey: DefaultsKeys.platformSettings)
        XCTAssertEqual(SettingsStore(defaults: defaults).values, .default)
    }

    @MainActor
    func testOlderSettingsDecodeWithDefaultsForMissingFields() throws {
        let suite = "SettingsStoreTests.\(UUID().uuidString)"
        let defaults = try XCTUnwrap(UserDefaults(suiteName: suite))
        defer { defaults.removePersistentDomain(forName: suite) }
        defaults.set(Data(#"{"instagram":{"blockReelRoutes":false}}"#.utf8), forKey: DefaultsKeys.platformSettings)

        let restored = SettingsStore(defaults: defaults).values
        XCTAssertFalse(restored.instagram.blockReelRoutes)
        XCTAssertTrue(restored.instagram.hideReelsTab)
        XCTAssertTrue(restored.instagram.hideStoryAds)
        XCTAssertEqual(restored.youtube, .default)
    }

    func testExplicitlyDisabledScrollReminderStaysDisabled() throws {
        let data = Data(#"{"instagram":{"scrollReminderMinutes":null}}"#.utf8)
        let settings = try JSONDecoder().decode(PlatformSettings.self, from: data)
        XCTAssertNil(settings.instagram.scrollReminderMinutes)
    }
}
