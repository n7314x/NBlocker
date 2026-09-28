import Foundation

struct PlatformSettings: Codable, Equatable, Sendable {
    var instagram: InstagramSettings
    var youtube: YouTubeSettings

    init(instagram: InstagramSettings, youtube: YouTubeSettings) {
        self.instagram = instagram
        self.youtube = youtube
    }

    private enum CodingKeys: String, CodingKey {
        case instagram, youtube
    }

    init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        instagram = values.decode(InstagramSettings.self, forKey: .instagram, default: .default)
        youtube = values.decode(YouTubeSettings.self, forKey: .youtube, default: .default)
    }

    static let `default` = PlatformSettings(
        instagram: .default,
        youtube: .default
    )
}
