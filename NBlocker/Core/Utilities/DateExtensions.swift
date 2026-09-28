import Foundation

extension TimeInterval {
    var compactDuration: String {
        let totalMinutes = max(0, Int(self) / 60)
        if totalMinutes < 60 { return "\(totalMinutes)m" }
        return "\(totalMinutes / 60)h \(totalMinutes % 60)m"
    }
}

extension Date {
    var shortWeekday: String {
        formatted(.dateTime.weekday(.narrow))
    }
}
