import XCTest
@testable import NBlocker

final class RuleEngineTests: XCTestCase {
    func testInstagramRuleSelection() {
        var settings = PlatformSettings.default
        settings.instagram.hideExplore = false
        settings.instagram.hideSuggestedPosts = false
        settings.instagram.hideSponsoredPosts = false
        settings.instagram.hideRecommendedAccounts = false
        let ids = Set(RuleEngine().enabledRules(for: .instagram, settings: settings).map(\.id))
        XCTAssertTrue(ids.contains("instagram.reels.entries"))
        XCTAssertFalse(ids.contains("instagram.explore.entries"))
        XCTAssertTrue(ids.contains("instagram.feed.suggestions"), "Detection remains active for browser metrics")
        XCTAssertTrue(ids.contains("instagram.feed.ads"), "Ad detection remains active for browser metrics")
    }

    func testInstagramOptionalRulesMatchSettings() {
        var settings = PlatformSettings.default
        settings.instagram.blockPostSearch = true
        settings.instagram.scrollReminderPosts = 20
        let ids = Set(RuleEngine().enabledRules(for: .instagram, settings: settings).map(\.id))

        XCTAssertTrue(ids.contains("instagram.search.results"))
        XCTAssertTrue(ids.contains("instagram.scroll.reminders"))
    }

    func testYouTubeRuleSelection() {
        var settings = PlatformSettings.default
        settings.youtube.disableAutoplay = false
        let ids = Set(RuleEngine().enabledRules(for: .youtube, settings: settings).map(\.id))
        XCTAssertTrue(ids.contains("youtube.shorts.entries"))
        XCTAssertFalse(ids.contains("youtube.playback.autoplay"))
    }

    func testMasterSwitchLeavesOnlySharedInfrastructure() {
        var settings = PlatformSettings.default
        settings.instagram.filteringEnabled = false
        settings.youtube.filteringEnabled = false

        for platform in Platform.allCases {
            let rules = RuleEngine().enabledRules(for: platform, settings: settings)
            XCTAssertTrue(rules.allSatisfy { $0.platform == nil })
        }
    }

    func testDefaultRuleResourcesLoadFromApplicationBundle() throws {
        let engine = RuleEngine(bundle: .main)
        for platform in Platform.allCases {
            for rule in engine.enabledRules(for: platform, settings: .default) {
                let source = try engine.source(for: rule)
                XCTAssertFalse(source.isEmpty, "Empty resource for \(rule.id)")
            }
        }
    }

    func testRouteClassificationAndBlocking() throws {
        let reel = try XCTUnwrap(URL(string: "https://www.instagram.com/reel/abc/"))
        XCTAssertEqual(URLHelpers.classify(reel), .instagramReel(identifier: "abc"))
        XCTAssertEqual(
            NavigationGuard(platform: .instagram).disposition(for: reel, settings: .default),
            .block(reason: "Reels are blocked by your Instagram settings")
        )

        let short = try XCTUnwrap(URL(string: "https://m.youtube.com/shorts/xyz"))
        XCTAssertEqual(URLHelpers.classify(short), .youtubeShort(identifier: "xyz"))
    }

    func testExternalAndUnsupportedURLs() throws {
        let external = try XCTUnwrap(URL(string: "https://example.com/path"))
        XCTAssertEqual(URLHelpers.classify(external), .external)
        let unsupported = try XCTUnwrap(URL(string: "mailto:test@example.com"))
        XCTAssertEqual(URLHelpers.classify(unsupported), .unsupported)
    }

    func testMasterFilterSwitchAllowsReelAndShortRoutes() throws {
        let reel = try XCTUnwrap(URL(string: "https://www.instagram.com/reel/abc/"))
        let short = try XCTUnwrap(URL(string: "https://m.youtube.com/shorts/xyz"))
        var settings = PlatformSettings.default
        settings.instagram.filteringEnabled = false
        settings.youtube.filteringEnabled = false

        XCTAssertEqual(NavigationGuard(platform: .instagram).disposition(for: reel, settings: settings), .allow)
        XCTAssertEqual(NavigationGuard(platform: .youtube).disposition(for: short, settings: settings), .allow)
    }

    func testHTTPPlatformRouteRedirectsToHTTPS() throws {
        let url = try XCTUnwrap(URL(string: "http://www.instagram.com/direct/inbox/"))
        let secureURL = try XCTUnwrap(URL(string: "https://www.instagram.com/direct/inbox/"))
        XCTAssertEqual(
            NavigationGuard(platform: .instagram).disposition(for: url, settings: .default),
            .redirect(secureURL)
        )
    }

    func testInstagramFirstPartyHostsStayInsideWrapper() throws {
        let home = try XCTUnwrap(URL(string: "https://www.instagram.com/"))
        let mobile = try XCTUnwrap(URL(string: "https://m.instagram.com/direct/inbox/"))
        let lookalike = try XCTUnwrap(URL(string: "https://instagram.com.example.com/"))

        XCTAssertEqual(NavigationGuard(platform: .instagram).disposition(for: home, settings: .default), .allow)
        XCTAssertEqual(NavigationGuard(platform: .instagram).disposition(for: mobile, settings: .default), .allow)
        XCTAssertEqual(NavigationGuard(platform: .instagram).disposition(for: lookalike, settings: .default), .requestExternalOpen)
    }

    func testClipboardWebURLValidation() throws {
        XCTAssertEqual(
            BrowserClipboardAction.url(from: " instagram.com/p/example/ "),
            try XCTUnwrap(URL(string: "https://instagram.com/p/example/"))
        )
        XCTAssertEqual(
            BrowserClipboardAction.url(from: "https://example.com/path"),
            try XCTUnwrap(URL(string: "https://example.com/path"))
        )
        XCTAssertNil(BrowserClipboardAction.url(from: "mailto:hello@example.com"))
        XCTAssertNil(BrowserClipboardAction.url(from: "not a link"))
    }

    func testTrustedAuthenticationHostsRemainInsideWebView() throws {
        let google = try XCTUnwrap(URL(string: "https://accounts.google.com/signin"))
        let facebook = try XCTUnwrap(URL(string: "https://www.facebook.com/login"))
        XCTAssertEqual(NavigationGuard(platform: .youtube).disposition(for: google, settings: .default), .allow)
        XCTAssertEqual(NavigationGuard(platform: .instagram).disposition(for: facebook, settings: .default), .allow)
        XCTAssertEqual(NavigationGuard(platform: .instagram).disposition(for: google, settings: .default), .requestExternalOpen)
    }

    func testYouTubeSearchCanBeDisabledIndependently() throws {
        let search = try XCTUnwrap(URL(string: "https://m.youtube.com/results?search_query=swift"))
        var settings = PlatformSettings.default
        settings.youtube.allowSearch = false

        XCTAssertEqual(
            NavigationGuard(platform: .youtube).disposition(for: search, settings: settings),
            .block(reason: "Search is blocked by your YouTube settings")
        )
    }

    func testBridgeAllowsKnownRuleIDsAndRejectsArbitraryLogContent() {
        XCTAssertEqual(
            WebMessageHandler.event(from: ["event": "ruleError", "rule": "instagram.reels.entries"]),
            .ruleError(identifier: "instagram.reels.entries")
        )
        XCTAssertEqual(
            WebMessageHandler.event(from: ["event": "ruleError", "rule": "private page text"]),
            .ruleError(identifier: "unknown")
        )
        XCTAssertEqual(
            WebMessageHandler.event(from: ["event": "navigationPrevented", "route": "short"]),
            .navigationPrevented(route: .short)
        )
        XCTAssertNil(WebMessageHandler.event(from: ["event": "navigationPrevented", "route": "unknown"]))
        XCTAssertNil(WebMessageHandler.event(from: ["event": "scroll", "direction": "sideways"]))
        XCTAssertEqual(
            WebMessageHandler.event(from: ["event": "metrics", "ads": 2, "suggested": 7, "blockable": 3]),
            .metrics(ads: 2, suggested: 7, blockable: 3)
        )
        XCTAssertNil(WebMessageHandler.event(from: ["event": "metrics", "ads": -1, "suggested": 0, "blockable": 0]))
        XCTAssertEqual(
            WebMessageHandler.event(from: ["event": "scrollReminder", "kind": "posts"]),
            .scrollReminder(kind: .posts)
        )
    }

    func testBrowserSessionElapsedText() {
        let openedAt = Date(timeIntervalSince1970: 1_000)
        let session = BrowserSession(platform: .instagram, openedAt: openedAt)

        XCTAssertEqual(session.elapsedText(at: openedAt.addingTimeInterval(96)), "01:36")
        XCTAssertEqual(session.elapsedText(at: openedAt.addingTimeInterval(3_661)), "1:01:01")
    }
}
