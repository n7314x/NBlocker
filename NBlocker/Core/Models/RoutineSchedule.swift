import Foundation

enum Weekday: Int, Codable, CaseIterable, Identifiable, Sendable {
    case sunday = 1
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday

    var id: Int { rawValue }

    var shortName: String {
        Calendar.current.shortWeekdaySymbols[rawValue - 1]
    }
}

struct RoutineSchedule: Codable, Equatable, Sendable {
    var days: Set<Weekday>
    var startMinutes: Int
    var endMinutes: Int

    init(days: Set<Weekday> = Set(Weekday.allCases), startMinutes: Int = 0, endMinutes: Int = 1_440) {
        self.days = days
        self.startMinutes = min(max(startMinutes, 0), 1_439)
        self.endMinutes = min(max(endMinutes, 0), 1_440)
    }

    private enum CodingKeys: String, CodingKey {
        case days, startMinutes, endMinutes
    }

    init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.init(
            days: values.decode(Set<Weekday>.self, forKey: .days, default: Set(Weekday.allCases)),
            startMinutes: values.decode(Int.self, forKey: .startMinutes, default: 0),
            endMinutes: values.decode(Int.self, forKey: .endMinutes, default: 1_440)
        )
    }

    func contains(_ date: Date, calendar: Calendar = .current) -> Bool {
        let components = calendar.dateComponents([.weekday, .hour, .minute], from: date)
        guard
            let weekdayValue = components.weekday,
            let weekday = Weekday(rawValue: weekdayValue),
            let hour = components.hour,
            let minute = components.minute
        else { return false }

        let minuteOfDay = hour * 60 + minute
        if startMinutes < endMinutes {
            return days.contains(weekday) && minuteOfDay >= startMinutes && minuteOfDay < endMinutes
        }
        if startMinutes == endMinutes {
            return days.contains(weekday)
        }
        if minuteOfDay >= startMinutes {
            return days.contains(weekday)
        }
        guard let yesterday = calendar.date(byAdding: .day, value: -1, to: date) else { return false }
        let yesterdayValue = calendar.component(.weekday, from: yesterday)
        return minuteOfDay < endMinutes && Weekday(rawValue: yesterdayValue).map(days.contains) == true
    }

    func activeIntervalEnd(containing date: Date, calendar: Calendar = .current) -> Date? {
        guard contains(date, calendar: calendar) else { return nil }

        let startOfDay = calendar.startOfDay(for: date)
        let minuteOfDay = calendar.component(.hour, from: date) * 60 + calendar.component(.minute, from: date)
        let endDayOffset: Int

        if startMinutes < endMinutes {
            endDayOffset = 0
        } else if startMinutes == endMinutes {
            endDayOffset = 1
        } else {
            endDayOffset = minuteOfDay >= startMinutes ? 1 : 0
        }

        guard let endDay = calendar.date(byAdding: .day, value: endDayOffset, to: startOfDay) else {
            return nil
        }
        if endMinutes == 1_440 {
            return calendar.date(byAdding: .day, value: 1, to: endDay)
        }
        return calendar.date(
            bySettingHour: endMinutes / 60,
            minute: endMinutes % 60,
            second: 0,
            of: endDay,
            matchingPolicy: .nextTime
        )
    }
}
