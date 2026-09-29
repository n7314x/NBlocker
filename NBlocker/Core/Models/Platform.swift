import Foundation

enum Platform: String, Codable, CaseIterable, Identifiable, Hashable, Sendable {
    case instagram
    case youtube

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .instagram: "Instagram"
        case .youtube: "YouTube"
        }
    }

    var symbolName: String {
        switch self {
        case .instagram: "camera.fill"
        case .youtube: "play.rectangle.fill"
        }
    }

    var startURL: URL {
        switch self {
        case .instagram: URL(string: "https://www.instagram.com/")!
        case .youtube: URL(string: "https://m.youtube.com/")!
        }
    }

    var settingsTitle: String { "\(displayName) Settings" }
}
