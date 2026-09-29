import Foundation

struct BrowserSessionStore {
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func save(_ url: URL, for platform: Platform) {
        guard URLHelpers.isRestorableWebURL(url, for: platform) else { return }
        defaults.set(url.absoluteString, forKey: DefaultsKeys.lastBrowserURL(for: platform))
    }

    func restoredURL(for platform: Platform, settings: PlatformSettings) -> URL? {
        guard
            let value = defaults.string(forKey: DefaultsKeys.lastBrowserURL(for: platform)),
            let url = URL(string: value),
            URLHelpers.isRestorableWebURL(url, for: platform),
            NavigationGuard(platform: platform).disposition(
                for: url,
                settings: settings,
                context: .explicitRequest
            ) == .allow
        else { return nil }
        return url
    }
}
