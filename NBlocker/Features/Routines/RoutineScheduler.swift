import Foundation

struct RoutineScheduler: Sendable {
    func activeRoutine(
        from routines: [Routine],
        at date: Date,
        calendar: Calendar = .current
    ) -> Routine? {
        routines.first { $0.isEnabled && $0.schedule.contains(date, calendar: calendar) }
    }
}
