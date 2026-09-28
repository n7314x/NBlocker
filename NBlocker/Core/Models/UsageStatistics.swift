import Foundation

struct UsageStatistics: Equatable, Sendable {
    var duration: TimeInterval
    var sessions: Int
    var longestSession: TimeInterval
    var preventedNavigations: Int
    var remindersTriggered: Int

    static let zero = UsageStatistics(
        duration: 0,
        sessions: 0,
        longestSession: 0,
        preventedNavigations: 0,
        remindersTriggered: 0
    )
}

struct DailyUsage: Identifiable, Equatable, Sendable {
    var date: Date
    var duration: TimeInterval
    var id: Date { date }
}
