import Foundation

enum BrowserPresentationState: Equatable, Sendable {
    case preparing
    case ready
    case failed(message: String)
}

struct BrowserMetrics: Equatable, Sendable {
    var ads = 0
    var suggested = 0
    var blockable = 0
    var hasReport = false
}

struct BrowserState: Equatable, Sendable {
    var presentation: BrowserPresentationState = .preparing
    var isLoading = false
    var estimatedProgress = 0.0
    var canGoBack = false
    var canGoForward = false
    var currentURL: URL?
    var hasAuthenticatedInstagramShell = false
    var message: String?
    var metrics = BrowserMetrics()
}

enum BrowserMetricsVisibility {
    static func shouldShowInstagramHomeMetrics(
        platform: Platform,
        presentation: BrowserPresentationState,
        currentURL: URL?,
        hasAuthenticatedInstagramShell: Bool
    ) -> Bool {
        guard
            platform == .instagram,
            presentation == .ready,
            hasAuthenticatedInstagramShell,
            let currentURL
        else { return false }

        return URLHelpers.isInstagramHomeFeedURL(currentURL)
    }
}
