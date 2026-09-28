import Foundation
import Observation

@MainActor
@Observable
final class SettingsStore {
    private(set) var values: PlatformSettings

    @ObservationIgnored private let defaults: UserDefaults
    @ObservationIgnored private let encoder = JSONEncoder()
    @ObservationIgnored private let decoder = JSONDecoder()

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        if
            let data = defaults.data(forKey: DefaultsKeys.platformSettings),
            let decoded = try? decoder.decode(PlatformSettings.self, from: data)
        {
            values = decoded
        } else {
            values = .default
        }
    }

    func updateInstagram(_ transform: (inout InstagramSettings) -> Void) {
        transform(&values.instagram)
        persist()
    }

    func updateYouTube(_ transform: (inout YouTubeSettings) -> Void) {
        transform(&values.youtube)
        persist()
    }

    func replaceInstagram(with settings: InstagramSettings) {
        values.instagram = settings
        persist()
    }

    func replaceYouTube(with settings: YouTubeSettings) {
        values.youtube = settings
        persist()
    }

    func reset() {
        values = .default
        persist()
    }

    private func persist() {
        guard let data = try? encoder.encode(values) else { return }
        defaults.set(data, forKey: DefaultsKeys.platformSettings)
    }
}
