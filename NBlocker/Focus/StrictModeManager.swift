import Foundation

struct StrictModeTiming: Equatable, Sendable {
    let requestedAt: Date
    let policy: StrictOverridePolicy
    let routineEndsAt: Date?

    var availableAt: Date? {
        if policy == .unavailableUntilRoutineEnds { return routineEndsAt }
        return policy.delay.map { requestedAt.addingTimeInterval($0) }
    }

    func isAvailable(at date: Date) -> Bool {
        availableAt.map { date >= $0 } ?? false
    }

    func progress(at date: Date) -> Double {
        guard let availableAt else { return 0 }
        let total = availableAt.timeIntervalSince(requestedAt)
        guard total > 0 else { return 1 }
        return min(max(date.timeIntervalSince(requestedAt) / total, 0), 1)
    }
}
