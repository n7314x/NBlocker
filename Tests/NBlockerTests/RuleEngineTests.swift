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
        XCTAssertTrue(ids.contains("instagram.explore.entries"))
        XCTAssertTrue(ids.contains("instagram.feed.suggestions"))
        XCTAssertTrue(ids.contains("instagram.feed.ads"))
    }

    func testInstagramOptionalRulesRemainAvailableForLiveChanges() {
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
        XCTAssertTrue(ids.contains("youtube.playback.autoplay"))
    }

    func testMasterSwitchKeepsDormantRulesAvailableForLiveUpdates() {
        var settings = PlatformSettings.default
        settings.instagram.filteringEnabled = false
        settings.youtube.filteringEnabled = false

        for platform in Platform.allCases {
            let rules = RuleEngine().enabledRules(for: platform, settings: settings)
            XCTAssertTrue(rules.contains { $0.platform == platform })
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

    func testInstagramAppURLIsMappedOrSilentlyIgnored() throws {
        let profile = try XCTUnwrap(URL(string: "instagram://user?username=nblocker.test"))
        let camera = try XCTUnwrap(URL(string: "instagram://story-camera"))
        let expected = try XCTUnwrap(URL(string: "https://www.instagram.com/nblocker.test/"))

        XCTAssertEqual(
            NavigationGuard(platform: .instagram).disposition(for: profile, settings: .default),
            .redirect(expected)
        )
        XCTAssertEqual(
            NavigationGuard(platform: .instagram).disposition(for: camera, settings: .default),
            .cancelSilently
        )
    }

    func testUnsupportedSubframeNavigationIsSilent() throws {
        let url = try XCTUnwrap(URL(string: "unknown-app://background-operation"))
        let context = NavigationContext(isMainFrame: false, isUserInitiated: false)

        XCTAssertEqual(
            NavigationGuard(platform: .instagram).disposition(for: url, settings: .default, context: context),
            .cancelSilently
        )
    }

    func testBackgroundInternalNavigationIsSilent() throws {
        let url = try XCTUnwrap(URL(string: "about:blank"))
        let context = NavigationContext(isMainFrame: true, isUserInitiated: false)

        XCTAssertEqual(
            NavigationGuard(platform: .instagram).disposition(for: url, settings: .default, context: context),
            .cancelSilently
        )
    }

    func testExternalTopLevelLinkStillRequestsExplicitOpen() throws {
        let url = try XCTUnwrap(URL(string: "https://example.com/path"))
        let context = NavigationContext(isMainFrame: true, isUserInitiated: true)

        XCTAssertEqual(
            NavigationGuard(platform: .instagram).disposition(for: url, settings: .default, context: context),
            .requestExternalOpen
        )
    }

    func testSettingsDismissalWithoutChangesDoesNotReloadOrNavigate() {
        let settings = PlatformSettings.default
        let plan = BrowserSettingsUpdate.plan(for: .instagram, current: settings, updated: settings)

        XCTAssertEqual(plan, .noChange)
        XCTAssertFalse(plan.requestsReload)
        XCTAssertNil(plan.navigationTarget)
    }

    func testSettingsChangesApplyLiveWithoutReloadOrHomeNavigation() {
        let current = PlatformSettings.default
        var updated = current
        updated.instagram.hideExplore.toggle()
        let plan = BrowserSettingsUpdate.plan(for: .instagram, current: current, updated: updated)

        XCTAssertEqual(plan, .applyLive)
        XCTAssertFalse(plan.requestsReload)
        XCTAssertNil(plan.navigationTarget)
    }

    func testChangedSettingsProduceUpdatedLiveConfiguration() throws {
        var settings = PlatformSettings.default
        settings.instagram.hideExplore = false

        let json = try RuleEngine().configurationJSON(platform: .instagram, settings: settings)
        let data = try XCTUnwrap(json.data(using: .utf8))
        let object = try XCTUnwrap(JSONSerialization.jsonObject(with: data) as? [String: Any])

        XCTAssertEqual(object["hideExplore"] as? Bool, false)
    }

    func testBrowserViewportLayoutIsFixedAndHasNoMenuState() {
        let layout = BrowserViewportLayout.fullScreen

        XCTAssertEqual(layout.contentInset, .zero)
        XCTAssertEqual(layout.scrollIndicatorInsets, .zero)
        XCTAssertEqual(layout.adjustmentBehavior, .never)
    }

    func testPlatformBrowserDoesNotPassMenuVisibilityIntoWebView() throws {
        let source = try repositorySource(at: "NBlocker/Features/Instagram/InstagramView.swift")

        XCTAssertTrue(source.contains("WebView(model: model)"))
        XCTAssertFalse(source.contains("browserMenuVisible"))
    }

    func testExploreRulePreservesSearchAndSeparatesDiscoveryContent() throws {
        let source = try instagramRuleSource(id: "instagram.explore.entries")

        XCTAssertTrue(InstagramSettings.default.hideExplore)
        XCTAssertTrue(InstagramSettings.default.allowAccountSearch)
        XCTAssertFalse(InstagramSettings.default.blockPostSearch)
        XCTAssertTrue(source.contains("if (navigation?.isSearchControl(entry)) continue"))
        XCTAssertTrue(source.contains("instagram.explore.discovery"))
        XCTAssertTrue(source.contains("if (!isExploreLanding || hasSearchRoute) return"))
        XCTAssertTrue(source.contains("if (hasSearchText) return"))
    }

    func testReelNavigationUsesSafeItemWrapperHiding() throws {
        let source = try instagramRuleSource(id: "instagram.reels.entries")

        XCTAssertTrue(source.contains("instagramNavigation?.hideItem(anchor"))
        XCTAssertTrue(source.contains("instagram.reels.tab"))
    }

    func testInstagramNavigationCompactionResourceAndStylesAreIncluded() throws {
        let navigation = try instagramRuleSource(id: "instagram.navigation")
        let styles = try instagramRuleSource(id: "instagram.style")

        XCTAssertTrue(navigation.contains("nblockerCompactNav"))
        XCTAssertTrue(navigation.contains("nblockerNavItem"))
        XCTAssertTrue(styles.contains("data-nblocker-compact-nav"))
        XCTAssertTrue(styles.contains("flex: 1 1 0"))
    }

    func testBrowserSessionRestoresSafeURLButNotBlockedReel() throws {
        let suite = "BrowserSessionStoreTests.\(UUID().uuidString)"
        let defaults = try XCTUnwrap(UserDefaults(suiteName: suite))
        defer { defaults.removePersistentDomain(forName: suite) }
        let store = BrowserSessionStore(defaults: defaults)
        let profile = try XCTUnwrap(URL(string: "https://www.instagram.com/nblocker/"))
        let reel = try XCTUnwrap(URL(string: "https://www.instagram.com/reel/abc/"))

        store.save(profile, for: .instagram)
        XCTAssertEqual(store.restoredURL(for: .instagram, settings: .default), profile)

        store.save(reel, for: .instagram)
        XCTAssertNil(store.restoredURL(for: .instagram, settings: .default))
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

    private func instagramRuleSource(id: String) throws -> String {
        let rule = try XCTUnwrap(
            RuleEngine().enabledRules(for: .instagram, settings: .default).first { $0.id == id }
        )
        return try RuleEngine(bundle: .main).source(for: rule)
    }

    private func repositorySource(at relativePath: String) throws -> String {
        let repositoryRoot = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
        return try String(contentsOf: repositoryRoot.appendingPathComponent(relativePath), encoding: .utf8)
    }
}
