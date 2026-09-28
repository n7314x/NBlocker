import Foundation

enum StrictOverridePolicy: String, Codable, CaseIterable, Identifiable, Sendable {
    case immediate
    case holdFiveSeconds
    case delayThirtySeconds
    case delayOneMinute
    case delayFiveMinutes
    case delayFifteenMinutes
    case unavailableUntilRoutineEnds

    var id: String { rawValue }

    var title: String {
        switch self {
        case .immediate: "Immediate"
        case .holdFiveSeconds: "Hold for 5 seconds"
        case .delayThirtySeconds: "30-second delay"
        case .delayOneMinute: "1-minute delay"
        case .delayFiveMinutes: "5-minute delay"
        case .delayFifteenMinutes: "15-minute delay"
        case .unavailableUntilRoutineEnds: "Unavailable until routine ends"
        }
    }

    var delay: TimeInterval? {
        switch self {
        case .immediate: 0
        case .holdFiveSeconds: 5
        case .delayThirtySeconds: 30
        case .delayOneMinute: 60
        case .delayFiveMinutes: 300
        case .delayFifteenMinutes: 900
        case .unavailableUntilRoutineEnds: nil
        }
    }
}

struct StrictModeConfiguration: Codable, Equatable, Sendable {
    var isEnabled: Bool
    var overridePolicy: StrictOverridePolicy

    init(
        isEnabled: Bool = false,
        overridePolicy: StrictOverridePolicy = .delayOneMinute
    ) {
        self.isEnabled = isEnabled
        self.overridePolicy = overridePolicy
    }

    private enum CodingKeys: String, CodingKey {
        case isEnabled, overridePolicy
    }

    init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        isEnabled = values.decode(Bool.self, forKey: .isEnabled, default: false)
        overridePolicy = values.decode(
            StrictOverridePolicy.self,
            forKey: .overridePolicy,
            default: .delayOneMinute
        )
    }
}
