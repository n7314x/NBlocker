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
    var message: String?
    var metrics = BrowserMetrics()
}
