import Foundation
import Observation
import UIKit
import WebKit

@MainActor
@Observable
final class WebViewModel {
    let platform: Platform
    private(set) var state = BrowserState()
    var pendingExternalURL: URL?
    var isToolbarVisible = true

    @ObservationIgnored private(set) weak var webView: WKWebView?
    @ObservationIgnored private var settings: PlatformSettings
    @ObservationIgnored private let ruleEngine: RuleEngine
    @ObservationIgnored private let usageTracker: UsageTracker

    init(
        platform: Platform,
        settings: PlatformSettings,
        ruleEngine: RuleEngine = RuleEngine(),
        usageTracker: UsageTracker
    ) {
        self.platform = platform
        self.settings = settings
        self.ruleEngine = ruleEngine
        self.usageTracker = usageTracker
    }

    var homeURL: URL {
        switch platform {
        case .instagram where settings.instagram.openToInbox:
            URL(string: "https://www.instagram.com/direct/inbox/") ?? platform.startURL
        case .youtube where settings.youtube.openToSubscriptions:
            URL(string: "https://m.youtube.com/feed/subscriptions") ?? platform.startURL
        default:
            platform.startURL
        }
    }

    func configure(_ configuration: WKWebViewConfiguration) throws {
        configuration.websiteDataStore = .default()
        configuration.allowsInlineMediaPlayback = true
        configuration.allowsPictureInPictureMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        try ruleEngine.install(
            platform: platform,
            settings: settings,
            into: configuration.userContentController
        )
    }

    func attach(_ webView: WKWebView) {
        self.webView = webView
        loadHome()
        usageTracker.begin(platform: platform)
    }

    func loadHome() {
        webView?.load(URLRequest(url: homeURL))
    }

    func goBack() { webView?.goBack() }
    func goForward() { webView?.goForward() }
    func reload() { webView?.reload() }

    func update(settings: PlatformSettings) {
        self.settings = settings
        guard let controller = webView?.configuration.userContentController else { return }
        do {
            try ruleEngine.install(platform: platform, settings: settings, into: controller)
            webView?.reload()
        } catch {
            state.message = "Rules could not be reloaded. The current page remains usable."
            AppLogger.logger(.rules).error("Rule reload failed: \(error.localizedDescription, privacy: .public)")
        }
    }

    func clearMessage() { state.message = nil }

    func openCurrentURLExternally() {
        guard let url = state.currentURL else { return }
        UIApplication.shared.open(url)
    }

    func openPendingExternalURL() {
        guard let url = pendingExternalURL else { return }
        pendingExternalURL = nil
        UIApplication.shared.open(url)
    }

    func stopTracking() {
        usageTracker.end()
    }

    func resumeTracking() {
        usageTracker.begin(platform: platform)
    }

    func navigationDisposition(for url: URL) -> NavigationDisposition {
        NavigationGuard(platform: platform).disposition(for: url, settings: settings)
    }

    func didBlockNavigation(reason: String) {
        state.message = reason
        usageTracker.recordPreventedNavigation()
    }

    func didStartNavigation(_ webView: WKWebView) {
        sync(from: webView)
        state.isLoading = true
    }

    func didFinishNavigation(_ webView: WKWebView) {
        sync(from: webView)
        state.isLoading = false
        state.estimatedProgress = 1
    }

    func didFailNavigation(_ webView: WKWebView) {
        sync(from: webView)
        state.isLoading = false
        state.message = "The page could not load. Check your connection and try again."
    }

    func sync(from webView: WKWebView) {
        state.canGoBack = webView.canGoBack
        state.canGoForward = webView.canGoForward
        state.currentURL = webView.url
        state.estimatedProgress = webView.estimatedProgress
    }

    func receiveBridgeMessage(_ body: Any) {
        guard let event = WebMessageHandler.event(from: body) else { return }
        switch event {
        case let .ruleError(identifier):
            AppLogger.logger(.rules).error("Web rule failed: \(identifier, privacy: .public)")
        case let .navigationPrevented(route):
            guard
                (platform == .instagram && route == .reel) ||
                (platform == .youtube && route == .short)
            else { return }
            usageTracker.recordPreventedNavigation()
            state.message = platform == .instagram ? "Reels are blocked by your settings" : "Shorts are blocked by your settings"
        case let .scroll(direction):
            isToolbarVisible = direction != .down
        }
    }
}
