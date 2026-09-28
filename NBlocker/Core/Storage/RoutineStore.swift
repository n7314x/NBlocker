import Foundation
import Observation

@MainActor
@Observable
final class RoutineStore {
    private(set) var routines: [Routine]

    @ObservationIgnored private let defaults: UserDefaults
    @ObservationIgnored private let encoder = JSONEncoder()
    @ObservationIgnored private let decoder = JSONDecoder()

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        if
            let data = defaults.data(forKey: DefaultsKeys.routines),
            let decoded = try? decoder.decode([Routine].self, from: data),
            !decoded.isEmpty
        {
            routines = decoded
        } else {
            routines = [.normal]
        }
    }

    func activeRoutine(at date: Date = .now, calendar: Calendar = .current) -> Routine? {
        routines.first { $0.isEnabled && $0.schedule.contains(date, calendar: calendar) }
    }

    func save(_ routine: Routine) {
        if let index = routines.firstIndex(where: { $0.id == routine.id }) {
            routines[index] = routine
        } else {
            routines.append(routine)
        }
        persist()
    }

    func remove(id: UUID) {
        routines.removeAll { $0.id == id }
        if routines.isEmpty { routines = [.normal] }
        persist()
    }

    private func persist() {
        guard let data = try? encoder.encode(routines) else { return }
        defaults.set(data, forKey: DefaultsKeys.routines)
    }
}
