import Foundation

struct NavigationGuard: Sendable {
    let platform: Platform

    func disposition(
        for url: URL,
        settings: PlatformSettings,
        context: NavigationContext = .explicitRequest
    ) -> NavigationDisposition {
        if !context.isMainFrame {
            return subframeDisposition(for: url)
        }

        if url.scheme?.lowercased() == "http", URLHelpers.isFirstPartyWebURL(url, for: platform) {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            components?.scheme = "https"
            if let secureURL = components?.url {
                return .redirect(secureURL)
            }
        }
        if URLHelpers.isFirstPartyWebURL(url, for: platform) {
            let disposition = platformDisposition(for: url, settings: settings)
            if case .block = disposition, !context.isUserInitiated {
                return .cancelSilently
            }
            return disposition
        }
        if URLHelpers.isTrustedAuthenticationURL(url, for: platform) {
            return .allow
        }

        if URLHelpers.isHarmlessInternalURL(url) {
            return context.isUserInitiated ? .allow : .cancelSilently
        }

        if platform == .instagram, URLHelpers.isKnownInstagramAppScheme(url) {
            guard context.isUserInitiated else { return .cancelSilently }
            if let webURL = URLHelpers.webURL(forInstagramAppURL: url) {
                return .redirect(webURL)
            }
            return .cancelSilently
        }

        let route = URLHelpers.classify(url)
        switch route {
        case .external:
            return context.isUserInitiated ? .requestExternalOpen : .cancelSilently
        case .unsupported:
            return context.isUserInitiated
                ? .block(reason: "This link can’t be opened in NBlocker")
                : .cancelSilently
        default:
            return context.isUserInitiated ? .requestExternalOpen : .cancelSilently
        }
    }

    private func subframeDisposition(for url: URL) -> NavigationDisposition {
        guard let scheme = url.scheme?.lowercased() else { return .allow }
        if ["http", "https", "about", "blob", "data", "javascript"].contains(scheme) {
            return .allow
        }
        return .cancelSilently
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
