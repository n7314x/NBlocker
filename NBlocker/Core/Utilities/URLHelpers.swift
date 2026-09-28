import Foundation

enum PlatformRoute: Equatable, Sendable {
    case instagramHome
    case instagramMessages
    case instagramReel(identifier: String?)
    case instagramExplore
    case instagramAccount
    case instagramContent
    case youtubeHome
    case youtubeSubscriptions
    case youtubeVideo(identifier: String?)
    case youtubeShort(identifier: String?)
    case youtubeSearch
    case youtubeContent
    case external
    case unsupported
}

enum URLHelpers {
    static func classify(_ url: URL) -> PlatformRoute {
        guard let scheme = url.scheme?.lowercased(), ["http", "https"].contains(scheme) else {
            return .unsupported
        }
        let host = (url.host ?? "").lowercased()
        let components = url.pathComponents.filter { $0 != "/" }

        if host == "instagram.com" || host == "www.instagram.com" {
            guard let first = components.first?.lowercased() else { return .instagramHome }
            switch first {
            case "direct": return .instagramMessages
            case "reel", "reels": return .instagramReel(identifier: components.dropFirst().first)
            case "explore": return .instagramExplore
            case "accounts": return .instagramAccount
            default: return .instagramContent
            }
        }

        if ["youtube.com", "www.youtube.com", "m.youtube.com"].contains(host) {
            guard let first = components.first?.lowercased() else { return .youtubeHome }
            switch first {
            case "feed" where components.dropFirst().first == "subscriptions":
                return .youtubeSubscriptions
            case "watch":
                let identifier = URLComponents(url: url, resolvingAgainstBaseURL: false)?
                    .queryItems?.first(where: { $0.name == "v" })?.value
                return .youtubeVideo(identifier: identifier)
            case "shorts": return .youtubeShort(identifier: components.dropFirst().first)
            case "results": return .youtubeSearch
            default: return .youtubeContent
            }
        }

        if host == "youtu.be" {
            return .youtubeVideo(identifier: components.first)
        }
        return .external
    }

    static func belongs(_ url: URL, to platform: Platform) -> Bool {
        switch (platform, classify(url)) {
        case (.instagram, .instagramHome), (.instagram, .instagramMessages),
             (.instagram, .instagramReel), (.instagram, .instagramExplore),
             (.instagram, .instagramAccount), (.instagram, .instagramContent),
             (.youtube, .youtubeHome), (.youtube, .youtubeSubscriptions),
             (.youtube, .youtubeVideo), (.youtube, .youtubeShort),
             (.youtube, .youtubeSearch), (.youtube, .youtubeContent):
            true
        default:
            false
        }
    }

    static func isTrustedAuthenticationURL(_ url: URL, for platform: Platform) -> Bool {
        guard url.scheme?.lowercased() == "https", let host = url.host?.lowercased() else {
            return false
        }
        let allowedDomains: [String]
        switch platform {
        case .instagram:
            allowedDomains = ["facebook.com"]
        case .youtube:
            allowedDomains = ["accounts.google.com", "myaccount.google.com", "consent.youtube.com", "accounts.youtube.com"]
        }
        return allowedDomains.contains { domain in
            host == domain || host.hasSuffix(".\(domain)")
        }
    }
}
