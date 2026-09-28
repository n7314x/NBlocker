import Foundation

struct Routine: Codable, Equatable, Identifiable, Sendable {
    var id: UUID
    var name: String
    var isEnabled: Bool
    var schedule: RoutineSchedule
    var settings: PlatformSettings
    var strictMode: StrictModeConfiguration
    var manualDuration: TimeInterval?
    var scrollLimit: Int?

    init(
        id: UUID = UUID(),
        name: String,
        isEnabled: Bool = true,
        schedule: RoutineSchedule,
        settings: PlatformSettings = .default,
        strictMode: StrictModeConfiguration = .init(),
        manualDuration: TimeInterval? = nil,
        scrollLimit: Int? = nil
    ) {
        self.id = id
        self.name = name
        self.isEnabled = isEnabled
        self.schedule = schedule
        self.settings = settings
        self.strictMode = strictMode
        self.manualDuration = manualDuration
        self.scrollLimit = scrollLimit
    }

    private enum CodingKeys: String, CodingKey {
        case id, name, isEnabled, schedule, settings, strictMode, manualDuration, scrollLimit
    }

    init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = values.decode(UUID.self, forKey: .id, default: UUID())
        name = values.decode(String.self, forKey: .name, default: "Custom")
        isEnabled = values.decode(Bool.self, forKey: .isEnabled, default: true)
        schedule = values.decode(RoutineSchedule.self, forKey: .schedule, default: RoutineSchedule())
        settings = values.decode(PlatformSettings.self, forKey: .settings, default: .default)
        strictMode = values.decode(StrictModeConfiguration.self, forKey: .strictMode, default: .init())
        manualDuration = try values.decodeIfPresent(TimeInterval.self, forKey: .manualDuration)
        scrollLimit = try values.decodeIfPresent(Int.self, forKey: .scrollLimit)
    }

    static let normal = Routine(
        name: "Normal",
        schedule: RoutineSchedule(),
        strictMode: StrictModeConfiguration(isEnabled: false, overridePolicy: .immediate)
    )
}
