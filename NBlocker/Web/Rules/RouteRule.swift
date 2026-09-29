import Foundation

enum NavigationDisposition: Equatable, Sendable {
    case allow
    case redirect(URL)
    case block(reason: String)
    case cancelSilently
    case requestExternalOpen
}

struct NavigationContext: Equatable, Sendable {
    let isMainFrame: Bool
    let isUserInitiated: Bool

    static let explicitRequest = NavigationContext(isMainFrame: true, isUserInitiated: true)
}
