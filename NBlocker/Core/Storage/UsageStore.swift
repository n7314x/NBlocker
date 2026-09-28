import Foundation
import Observation

@MainActor
@Observable
final class UsageStore {
    private(set) var sessions: [UsageSession]

    @ObservationIgnored private let defaults: UserDefaults
    @ObservationIgnored private let encoder = JSONEncoder()
    @ObservationIgnored private let decoder = JSONDecoder()
    @ObservationIgnored private let maximumSessions = Constants.maximumStoredUsageSessions

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        if
            let data = defaults.data(forKey: DefaultsKeys.usageSessions),
            let decoded = try? decoder.decode([UsageSession].self, from: data)
        {
            sessions = decoded.map { session in
                guard session.endedAt == nil else { return session }
                var recovered = session
                recovered.endedAt = recovered.startedAt
                return recovered
            }
            if sessions != decoded, let repairedData = try? encoder.encode(sessions) {
                defaults.set(repairedData, forKey: DefaultsKeys.usageSessions)
            }
        } else {
            sessions = []
        }
    }

    func upsert(_ session: UsageSession) {
        if let index = sessions.firstIndex(where: { $0.id == session.id }) {
            sessions[index] = session
        } else {
            sessions.append(session)
        }
        sessions = Array(sessions.sorted { $0.startedAt < $1.startedAt }.suffix(maximumSessions))
        persist()
    }

    func statistics(
        for platform: Platform? = nil,
        on date: Date = .now,
        calendar: Calendar = .current,
        asOf now: Date = .now
    ) -> UsageStatistics {
        guard let day = calendar.dateInterval(of: .day, for: date) else { return .zero }
        let platformSessions = sessions.filter { platform == nil || $0.platform == platform }
        let overlapping = platformSessions.compactMap { session -> TimeInterval? in
            let end = session.endedAt ?? now
            let overlapStart = max(session.startedAt, day.start)
            let overlapEnd = min(end, day.end)
            let duration = overlapEnd.timeIntervalSince(overlapStart)
            return duration > 0 ? duration : nil
        }
        let sessionsStartedThatDay = platformSessions.filter {
            calendar.isDate($0.startedAt, inSameDayAs: date)
        }
        return UsageStatistics(
            duration: overlapping.reduce(0, +),
            sessions: overlapping.count,
            longestSession: overlapping.max() ?? 0,
            preventedNavigations: sessionsStartedThatDay.reduce(0) { $0 + $1.preventedNavigations },
            remindersTriggered: sessionsStartedThatDay.reduce(0) { $0 + $1.remindersTriggered }
        )
    }

    func lastSevenDays(asOf date: Date = .now, calendar: Calendar = .current) -> [DailyUsage] {
        (0..<7).reversed().compactMap { offset in
            guard let day = calendar.date(byAdding: .day, value: -offset, to: date) else { return nil }
            return DailyUsage(
                date: calendar.startOfDay(for: day),
                duration: statistics(on: day, calendar: calendar, asOf: date).duration
            )
        }
    }

    func clear() {
        sessions = []
        defaults.removeObject(forKey: DefaultsKeys.usageSessions)
    }

    private func persist() {
        guard let data = try? encoder.encode(sessions) else { return }
        defaults.set(data, forKey: DefaultsKeys.usageSessions)
    }
}
