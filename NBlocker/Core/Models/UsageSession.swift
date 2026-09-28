import Foundation

struct UsageSession: Codable, Equatable, Identifiable, Sendable {
    var id: UUID
    var platform: Platform
    var startedAt: Date
    var endedAt: Date?
    var preventedNavigations: Int
    var remindersTriggered: Int

    init(
        id: UUID = UUID(),
        platform: Platform,
        startedAt: Date,
        endedAt: Date? = nil,
        preventedNavigations: Int = 0,
        remindersTriggered: Int = 0
    ) {
        self.id = id
        self.platform = platform
        self.startedAt = startedAt
        self.endedAt = endedAt
        self.preventedNavigations = preventedNavigations
        self.remindersTriggered = remindersTriggered
    }

    private enum CodingKeys: String, CodingKey {
        case id, platform, startedAt, endedAt, preventedNavigations, remindersTriggered
    }

    init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(UUID.self, forKey: .id)
        platform = try values.decode(Platform.self, forKey: .platform)
        startedAt = try values.decode(Date.self, forKey: .startedAt)
        endedAt = try values.decodeIfPresent(Date.self, forKey: .endedAt)
        preventedNavigations = values.decode(Int.self, forKey: .preventedNavigations, default: 0)
        remindersTriggered = values.decode(Int.self, forKey: .remindersTriggered, default: 0)
    }

    func duration(asOf date: Date = .now) -> TimeInterval {
        max(0, (endedAt ?? date).timeIntervalSince(startedAt))
    }
}
