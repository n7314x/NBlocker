import Foundation
import Observation

@MainActor
@Observable
final class UsageTracker {
    private(set) var activeSession: UsageSession?
    @ObservationIgnored private let store: UsageStore

    init(store: UsageStore) {
        self.store = store
    }

    func begin(platform: Platform, at date: Date = .now) {
        guard activeSession?.platform != platform else { return }
        end(at: date)
        let session = UsageSession(platform: platform, startedAt: date)
        activeSession = session
        store.upsert(session)
    }

    func recordPreventedNavigation() {
        guard var session = activeSession else { return }
        session.preventedNavigations += 1
        activeSession = session
        store.upsert(session)
    }

    func recordReminder() {
        guard var session = activeSession else { return }
        session.remindersTriggered += 1
        activeSession = session
        store.upsert(session)
    }

    func end(at date: Date = .now) {
        guard var session = activeSession else { return }
        session.endedAt = max(date, session.startedAt)
        store.upsert(session)
        activeSession = nil
    }
}
