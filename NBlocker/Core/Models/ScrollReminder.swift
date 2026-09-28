import Foundation

enum ScrollReminderTrigger: Codable, Equatable, Sendable {
    case minutes(Int)
    case posts(Int)
}

enum ScrollReminderAction: String, Codable, CaseIterable, Sendable {
    case reminder
    case fullScreen
    case confirmation
    case returnHome
    case endSession
}

struct ScrollReminder: Codable, Equatable, Sendable {
    var isEnabled = false
    var trigger: ScrollReminderTrigger = .minutes(10)
    var action: ScrollReminderAction = .reminder
    var followUpMinutes: Int? = 5
    var followUpPosts: Int?
}
