import Foundation

struct BrowserState: Equatable, Sendable {
    var isLoading = false
    var estimatedProgress = 0.0
    var canGoBack = false
    var canGoForward = false
    var currentURL: URL?
    var message: String?
}
