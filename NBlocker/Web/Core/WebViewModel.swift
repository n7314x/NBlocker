import Foundation
import Observation
import UIKit
import WebKit

enum BrowserSettingsUpdate: Equatable, Sendable {
    case noChange
    case applyLive

    static func plan(
        for platform: Platform,
        current: PlatformSettings,
        updated: PlatformSettings
    ) -> BrowserSettingsUpdate {
        switch platform {
        case .instagram:
            current.instagram == updated.instagram ? .noChange : .applyLive
        case .youtube:
            current.youtube == updated.youtube ? .noChange : .applyLive
        }
    }

    var requestsReload: Bool { false }
    var navigationTarget: URL? { nil }
}

@MainActor
@Observable
final class WebViewModel {
    let platform: Platform
    let session: BrowserSession
    private(set) var state = BrowserState()
    var pendingExternalURL: URL?

    @ObservationIgnored private(set) var webView: WKWebView?
    @ObservationIgnored private var settings: PlatformSettings
    @ObservationIgnored private let ruleEngine: RuleEngine
    @ObservationIgnored private let usageTracker: UsageTracker
    @ObservationIgnored private let browserSessionStore: BrowserSessionStore
    @ObservationIgnored private let minimumPreparationDuration: TimeInterval
    @ObservationIgnored private var preparationStartedAt = Date.now
    @ObservationIgnored private var presentationTask: Task<Void, Never>?

    init(
        platform: Platform,
        settings: PlatformSettings,
        ruleEngine: RuleEngine = RuleEngine(),
        usageTracker: UsageTracker,
        browserSessionStore: BrowserSessionStore = BrowserSessionStore(),
        minimumPreparationDuration: TimeInterval = 0.7
    ) {
        self.platform = platform
        self.session = BrowserSession(platform: platform)
        self.settings = settings
        self.ruleEngine = ruleEngine
        self.usageTracker = usageTracker
        self.browserSessionStore = browserSessionStore
        self.minimumPreparationDuration = minimumPreparationDuration
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

    var isFilteringEnabled: Bool {
        switch platform {
        case .instagram: settings.instagram.filteringEnabled
        case .youtube: settings.youtube.filteringEnabled
        }
    }

    var shouldShowInstagramHomeMetrics: Bool {
        BrowserMetricsVisibility.shouldShowInstagramHomeMetrics(
            platform: platform,
            presentation: state.presentation,
            currentURL: state.currentURL,
            hasAuthenticatedInstagramShell: state.hasAuthenticatedInstagramShell
        )
    }

    func configure(_ configuration: WKWebViewConfiguration) throws {
        configuration.websiteDataStore = .default()
        configuration.limitsNavigationsToAppBoundDomains = false
        configuration.allowsInlineMediaPlayback = true
        configuration.allowsPictureInPictureMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        configuration.defaultWebpagePreferences.preferredContentMode = .mobile
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        try ruleEngine.install(
            platform: platform,
            settings: settings,
            into: configuration.userContentController
        )
    }

    func attach(_ webView: WKWebView) {
        guard self.webView !== webView else { return }
        self.webView = webView
        beginPreparation()
        loadInitialPage()
        usageTracker.begin(platform: platform)
    }

    func loadHome() {
        load(homeURL)
    }

    func goBack() { webView?.goBack() }
    func goForward() { webView?.goForward() }
    func reload() { webView?.reload() }

    func retry() {
        beginPreparation()
        if webView?.url == nil {
            loadHome()
        } else {
            webView?.reload()
        }
    }

    func load(_ url: URL) {
        willNavigate(to: url)
        webView?.load(URLRequest(url: url))
    }

    func openURLRespectingNavigationPolicy(_ url: URL) {
        switch navigationDisposition(for: url) {
        case .allow:
            load(url)
        case let .redirect(secureURL):
            load(secureURL)
        case let .block(reason):
            didBlockNavigation(reason: reason)
        case .cancelSilently:
            break
        case .requestExternalOpen:
            pendingExternalURL = url
        }
    }

    @discardableResult
    func openClipboardURL() -> Bool {
        let pasteboard = UIPasteboard.general
        let candidate = pasteboard.url?.absoluteString ?? pasteboard.string
        guard let url = BrowserClipboardAction.url(from: candidate) else {
            state.message = "Copy a valid web link, then try again."
            HapticManager.play(.warning)
            return false
        }
        openURLRespectingNavigationPolicy(url)
        return true
    }

    @discardableResult
    func update(settings newSettings: PlatformSettings) -> BrowserSettingsUpdate {
        let update = settingsUpdate(for: newSettings)
        settings = newSettings
        guard update == .applyLive else { return .noChange }
        guard let webView else { return .applyLive }
        do {
            let json = try ruleEngine.configurationJSON(platform: platform, settings: settings)
            do {
                try ruleEngine.install(
                    platform: platform,
                    settings: settings,
                    into: webView.configuration.userContentController
                )
            } catch {
                AppLogger.logger(.rules).error("Future rule update failed: \(error.localizedDescription, privacy: .public)")
            }
            let source = """
            (() => {
              const config = \(json);
              if (!window.NBlocker?.updateConfig(config)) return false;
              return window.NBlocker.reapplyRules();
            })();
            """
            Task { @MainActor [weak webView] in
                do {
                    _ = try await webView?.evaluateJavaScript(source)
                } catch {
                    AppLogger.logger(.rules).error("Live rule update failed: \(error.localizedDescription, privacy: .public)")
                }
            }
        } catch {
            AppLogger.logger(.rules).error("Rule configuration encoding failed: \(error.localizedDescription, privacy: .public)")
        }
        return .applyLive
    }

    func clearMessage() { state.message = nil }

    func copyCurrentURL() {
        guard let url = state.currentURL else { return }
        UIPasteboard.general.url = url
        state.message = "Link copied"
    }

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

    func navigationDisposition(
        for url: URL,
        context: NavigationContext = .explicitRequest
    ) -> NavigationDisposition {
        NavigationGuard(platform: platform).disposition(for: url, settings: settings, context: context)
    }

    func handleNewWindowRequest(
        _ url: URL,
        context: NavigationContext,
        in webView: WKWebView
    ) {
        if !context.isUserInitiated || URLHelpers.isHarmlessInternalURL(url) {
            didCancelBackgroundNavigation()
            return
        }
        switch navigationDisposition(for: url, context: context) {
        case .allow:
            load(url)
        case let .redirect(secureURL):
            load(secureURL)
        case let .block(reason):
            didBlockNavigation(reason: reason)
        case .cancelSilently:
            didCancelBackgroundNavigation()
        case .requestExternalOpen:
            pendingExternalURL = url
        }
    }

    func didBlockNavigation(reason: String) {
        state.message = reason
        usageTracker.recordPreventedNavigation()
    }

    func didCancelBackgroundNavigation() {
        AppLogger.logger(.web).debug("Ignored non-user-visible browser navigation")
    }

    func didStartNavigation(_ webView: WKWebView) {
        if case .preparing = state.presentation {
            presentationTask?.cancel()
        }
        sync(from: webView)
        state.hasAuthenticatedInstagramShell = false
        state.isLoading = true
        state.estimatedProgress = max(webView.estimatedProgress, 0.05)
        state.metrics = BrowserMetrics()
    }

    func didCommitNavigation(_ webView: WKWebView) {
        sync(from: webView)
        state.message = nil
        saveRestorableURL(from: webView)
    }

    func didFinishNavigation(_ webView: WKWebView) {
        sync(from: webView)
        state.isLoading = false
        state.estimatedProgress = 1
        state.message = nil
        saveRestorableURL(from: webView)
        completePreparation(with: .ready)
    }

    func didFailNavigation(_ webView: WKWebView, error: any Error) {
        sync(from: webView)
        state.isLoading = false
        guard (error as NSError).code != NSURLErrorCancelled else { return }
        let message = "Check your connection and try again."
        if case .preparing = state.presentation {
            completePreparation(with: .failed(message: message))
        } else {
            state.message = "The page could not load. Check your connection and try again."
        }
    }

    func webContentProcessDidTerminate() {
        if case .preparing = state.presentation {
            completePreparation(with: .failed(message: "The browser stopped unexpectedly. Please try again."))
        } else {
            state.message = "The browser stopped unexpectedly. Reload to continue."
        }
    }

    func sync(from webView: WKWebView) {
        state.canGoBack = webView.canGoBack
        state.canGoForward = webView.canGoForward
        state.currentURL = webView.url
        state.estimatedProgress = webView.estimatedProgress
    }

    func willNavigate(to url: URL) {
        state.currentURL = url
        if platform == .instagram {
            state.hasAuthenticatedInstagramShell = false
        }
    }

    func didChangeInstagramNavigation(
        path: String,
        hasAuthenticatedInstagramShell: Bool
    ) {
        guard platform == .instagram else { return }
        let baseURL = webView?.url ?? state.currentURL ?? platform.startURL
        guard let url = URLHelpers.instagramURL(forReportedPath: path, relativeTo: baseURL) else {
            return
        }
        state.currentURL = url
        state.hasAuthenticatedInstagramShell = hasAuthenticatedInstagramShell
        browserSessionStore.save(url, for: platform)
    }

    func receiveBridgeMessage(_ body: Any) {
        guard let event = WebMessageHandler.event(from: body) else { return }
        switch event {
        case let .ruleError(identifier):
            AppLogger.logger(.rules).error("Web rule failed: \(identifier, privacy: .public)")
        case let .navigationChanged(path, hasAuthenticatedInstagramShell):
            didChangeInstagramNavigation(
                path: path,
                hasAuthenticatedInstagramShell: hasAuthenticatedInstagramShell
            )
        case let .navigationPrevented(route):
            guard
                (platform == .instagram && route == .reel) ||
                (platform == .youtube && route == .short)
            else { return }
            usageTracker.recordPreventedNavigation()
            state.message = platform == .instagram ? "Reels are blocked by your settings" : "Shorts are blocked by your settings"
        case .scroll:
            break
        case let .metrics(ads, suggested, blockable):
            state.metrics = BrowserMetrics(
                ads: ads,
                suggested: suggested,
                blockable: blockable,
                hasReport: true
            )
        case .scrollReminder:
            usageTracker.recordReminder()
            state.message = "Take a breath. You have been scrolling for a while."
        }
    }

    func blockVisibleDetections() {
        guard let webView else { return }
        Task { @MainActor [weak self, weak webView] in
            guard let self, let webView else { return }
            do {
                let result = try await webView.evaluateJavaScript(
                    "window.NBlocker?.performAction('blockDetectedItems') ?? 0;"
                )
                let count = (result as? NSNumber)?.intValue ?? 0
                state.message = count > 0 ? "Detected distractions hidden" : "No visible distractions to hide"
            } catch {
                state.message = "Those items could not be hidden on this page."
                AppLogger.logger(.rules).error("Detected-item action failed: \(error.localizedDescription, privacy: .public)")
            }
        }
    }

    private func beginPreparation() {
        presentationTask?.cancel()
        preparationStartedAt = .now
        state.presentation = .preparing
        state.message = nil
        state.estimatedProgress = 0
        state.metrics = BrowserMetrics()
    }

    func settingsUpdate(for newSettings: PlatformSettings) -> BrowserSettingsUpdate {
        BrowserSettingsUpdate.plan(for: platform, current: settings, updated: newSettings)
    }

    private func loadInitialPage() {
        let initialURL = browserSessionStore.restoredURL(for: platform, settings: settings) ?? homeURL
        load(initialURL)
    }

    private func saveRestorableURL(from webView: WKWebView) {
        guard let url = webView.url else { return }
        browserSessionStore.save(url, for: platform)
    }

    private func completePreparation(with presentation: BrowserPresentationState) {
        presentationTask?.cancel()
        let elapsed = Date.now.timeIntervalSince(preparationStartedAt)
        let remaining = max(0, minimumPreparationDuration - elapsed)
        presentationTask = Task { @MainActor [weak self] in
            if remaining > 0 {
                try? await Task.sleep(nanoseconds: UInt64(remaining * 1_000_000_000))
            }
            guard !Task.isCancelled else { return }
            self?.state.presentation = presentation
        }
    }
}
