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

    func elapsed(at date: Date = .now) -> TimeInterval {
        max(0, date.timeIntervalSince(openedAt))
    }

    func elapsedText(at date: Date = .now) -> String {
        let totalSeconds = Int(elapsed(at: date))
        let hours = totalSeconds / 3_600
        let minutes = (totalSeconds % 3_600) / 60
        let seconds = totalSeconds % 60
        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        }
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
