import XCTest
@testable import NBlocker

final class RoutineManagerTests: XCTestCase {
    func testDaytimeSchedule() throws {
        let calendar = testCalendar
        let schedule = RoutineSchedule(days: [.monday], startMinutes: 9 * 60, endMinutes: 17 * 60)
        XCTAssertTrue(schedule.contains(try date(2026, 9, 28, 12), calendar: calendar))
        XCTAssertFalse(schedule.contains(try date(2026, 9, 28, 18), calendar: calendar))
    }

    func testOvernightScheduleUsesPreviousDay() throws {
        let calendar = testCalendar
        let schedule = RoutineSchedule(days: [.monday], startMinutes: 22 * 60, endMinutes: 7 * 60)
        XCTAssertTrue(schedule.contains(try date(2026, 9, 28, 23), calendar: calendar))
        XCTAssertTrue(schedule.contains(try date(2026, 9, 29, 6), calendar: calendar))
        XCTAssertFalse(schedule.contains(try date(2026, 9, 29, 8), calendar: calendar))
    }

    func testActiveIntervalEndForOvernightSchedule() throws {
        let calendar = testCalendar
        let schedule = RoutineSchedule(days: [.monday], startMinutes: 22 * 60, endMinutes: 7 * 60)
        let mondayNight = try date(2026, 9, 28, 23)
        let tuesdayMorning = try date(2026, 9, 29, 6)
        let expected = try date(2026, 9, 29, 7)

        XCTAssertEqual(schedule.activeIntervalEnd(containing: mondayNight, calendar: calendar), expected)
        XCTAssertEqual(schedule.activeIntervalEnd(containing: tuesdayMorning, calendar: calendar), expected)
    }

    func testRoutineDecodesMissingNewFieldsWithDefaults() throws {
        let data = Data(#"[{"name":"Legacy","schedule":{}}]"#.utf8)
        let decoded = try JSONDecoder().decode([Routine].self, from: data)
        let routine = try XCTUnwrap(decoded.first)

        XCTAssertEqual(routine.name, "Legacy")
        XCTAssertTrue(routine.isEnabled)
        XCTAssertEqual(routine.settings, .default)
        XCTAssertEqual(routine.strictMode, StrictModeConfiguration())
    }

    private var testCalendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        return calendar
    }

    private func date(_ year: Int, _ month: Int, _ day: Int, _ hour: Int) throws -> Date {
        let components = DateComponents(
            calendar: testCalendar,
            timeZone: testCalendar.timeZone,
            year: year,
            month: month,
            day: day,
            hour: hour
        )
        return try XCTUnwrap(testCalendar.date(from: components))
    }
}
