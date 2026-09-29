import Foundation

struct NavigationGuard: Sendable {
    let platform: Platform

    func disposition(for url: URL, settings: PlatformSettings) -> NavigationDisposition {
        if url.scheme?.lowercased() == "http", URLHelpers.isFirstPartyWebURL(url, for: platform) {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            components?.scheme = "https"
            if let secureURL = components?.url {
                return .redirect(secureURL)
            }
        }
        if URLHelpers.isFirstPartyWebURL(url, for: platform) {
            return platformDisposition(for: url, settings: settings)
        }
        if URLHelpers.isTrustedAuthenticationURL(url, for: platform) {
            return .allow
        }

        let route = URLHelpers.classify(url)
        switch route {
        case .external:
            return .requestExternalOpen
        case .unsupported:
            return .block(reason: "Unsupported link")
        default:
            return .requestExternalOpen
        }
    }

    private func platformDisposition(for url: URL, settings: PlatformSettings) -> NavigationDisposition {
        let route = URLHelpers.classify(url)
        switch route {
        case .instagramReel where platform == .instagram &&
            settings.instagram.filteringEnabled && settings.instagram.blockReelRoutes:
            return .block(reason: "Reels are blocked by your Instagram settings")
        case .youtubeShort where platform == .youtube &&
            settings.youtube.filteringEnabled && settings.youtube.blockShortRoutes:
            return .block(reason: "Shorts are blocked by your YouTube settings")
        case .youtubeSearch where platform == .youtube &&
            settings.youtube.filteringEnabled && !settings.youtube.allowSearch:
            return .block(reason: "Search is blocked by your YouTube settings")
        default:
            return .allow
        }
    }
}
