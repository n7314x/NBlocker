import Observation

enum RootTab: String, CaseIterable, Identifiable, Hashable, Sendable {
    case sleep
    case activity
    case home
    case protection
    case profile

    var id: String { rawValue }

    var title: String { rawValue.capitalized }

    var symbolName: String {
        switch self {
        case .sleep: "moon.zzz"
        case .activity: "chart.bar"
        case .home: "house"
        case .protection: "shield"
        case .profile: "person.crop.circle"
        }
    }

    var selectedSymbolName: String {
        switch self {
        case .sleep: "moon.fill"
        case .activity: "chart.bar.fill"
        case .home: "house.fill"
        case .protection: "shield.fill"
        case .profile: "person.crop.circle.fill"
        }
    }
}

@MainActor
@Observable
final class AppRouter {
    var selectedTab: RootTab = .home
    var presentedBrowser: Platform?
    var presentedSettings: Platform?
}
