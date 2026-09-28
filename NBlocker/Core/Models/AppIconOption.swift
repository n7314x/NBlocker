import Foundation

enum AppIconOption: String, CaseIterable, Identifiable, Sendable {
    case defaultIcon
    case dark = "Dark"
    case glass = "Glass"
    case minimal = "Minimal"
    case instagramStyle = "InstagramStyle"
    case youtubeStyle = "YouTubeStyle"

    var id: String { rawValue }
    var alternateName: String? { self == .defaultIcon ? nil : rawValue }

    var title: String {
        switch self {
        case .defaultIcon: "NBlocker Default"
        case .dark: "NBlocker Dark"
        case .glass: "NBlocker Glass"
        case .minimal: "NBlocker Minimal"
        case .instagramStyle: "Instagram-style slot"
        case .youtubeStyle: "YouTube-style slot"
        }
    }

    var symbolName: String {
        switch self {
        case .defaultIcon: "app.fill"
        case .dark: "moon.fill"
        case .glass: "circle.hexagongrid.fill"
        case .minimal: "square"
        case .instagramStyle: "camera.fill"
        case .youtubeStyle: "play.rectangle.fill"
        }
    }
}
