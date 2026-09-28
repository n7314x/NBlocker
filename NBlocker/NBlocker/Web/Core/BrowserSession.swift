import Foundation

struct BrowserSession: Identifiable, Sendable {
    let id: UUID
    let platform: Platform
    let openedAt: Date

    init(platform: Platform, openedAt: Date = .now) {
        self.id = UUID()
        self.platform = platform
        self.openedAt = openedAt
    }
}
