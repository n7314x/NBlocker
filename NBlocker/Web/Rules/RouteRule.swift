import Foundation

enum NavigationDisposition: Equatable, Sendable {
    case allow
    case redirect(URL)
    case block(reason: String)
    case requestExternalOpen
}
