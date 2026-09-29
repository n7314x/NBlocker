import Foundation

enum DefaultsKeys {
    static let platformSettings = "settings.platforms.v1"
    static let routines = "routines.v1"
    static let usageSessions = "usage.sessions.v1"
    static func lastBrowserURL(for platform: Platform) -> String {
        "browser.lastURL.\(platform.rawValue).v1"
    }
}
