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

        if isInstagramFirstPartyHost(host) {
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

    static func isInstagramHomeFeedURL(_ url: URL) -> Bool {
        guard
            url.scheme?.lowercased() == "https",
            let host = url.host?.lowercased(),
            ["instagram.com", "www.instagram.com", "m.instagram.com"].contains(host),
            url.user == nil,
            url.password == nil,
            url.port == nil || url.port == 443
        else { return false }

        return url.pathComponents.filter { $0 != "/" }.isEmpty
    }

    static func instagramURL(forReportedPath path: String, relativeTo baseURL: URL) -> URL? {
        guard
            path.hasPrefix("/"),
            !path.hasPrefix("//"),
            !path.contains("?"),
            !path.contains("#"),
            isFirstPartyWebURL(baseURL, for: .instagram),
            let url = URL(string: path, relativeTo: baseURL)?.absoluteURL,
            isFirstPartyWebURL(url, for: .instagram)
        else { return nil }

        return url
    }

    static func isFirstPartyWebURL(_ url: URL, for platform: Platform) -> Bool {
        guard
            let scheme = url.scheme?.lowercased(),
            ["http", "https"].contains(scheme),
            let host = url.host?.lowercased()
        else { return false }

        switch platform {
        case .instagram:
            return isInstagramFirstPartyHost(host)
        case .youtube:
            return ["youtube.com", "www.youtube.com", "m.youtube.com", "youtu.be"].contains(host)
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

    static func webURL(forInstagramAppURL url: URL) -> URL? {
        guard url.scheme?.lowercased() == "instagram" else { return nil }
        let host = url.host?.lowercased()
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)

        if host == "user",
           let username = components?.queryItems?.first(where: { $0.name == "username" })?.value,
           isSafeInstagramPathComponent(username) {
            return URL(string: "https://www.instagram.com/\(username)/")
        }

        let pathComponents = url.pathComponents.filter { $0 != "/" }
        if host == "reels_audio", let identifier = pathComponents.first,
           isSafeInstagramPathComponent(identifier) {
            return URL(string: "https://www.instagram.com/reels/audio/\(identifier)/")
        }

        return nil
    }

    static func isHarmlessInternalURL(_ url: URL) -> Bool {
        guard let scheme = url.scheme?.lowercased() else { return true }
        return ["about", "blob", "data", "javascript"].contains(scheme)
    }

    static func isKnownInstagramAppScheme(_ url: URL) -> Bool {
        guard let scheme = url.scheme?.lowercased() else { return false }
        return scheme == "instagram" || scheme == "fb" || scheme == "facebook" ||
            scheme.hasPrefix("fb")
    }

    static func isRestorableWebURL(_ url: URL, for platform: Platform) -> Bool {
        guard url.scheme?.lowercased() == "https", isFirstPartyWebURL(url, for: platform) else {
            return false
        }
        guard !isTransientAuthenticationURL(url) else { return false }
        return true
    }

    private static func isInstagramFirstPartyHost(_ host: String) -> Bool {
        host == "instagram.com" || host.hasSuffix(".instagram.com")
    }

    private static func isSafeInstagramPathComponent(_ value: String) -> Bool {
        !value.isEmpty && value.range(of: "^[A-Za-z0-9._-]+$", options: .regularExpression) != nil
    }

    private static func isTransientAuthenticationURL(_ url: URL) -> Bool {
        let path = url.path.lowercased()
        if path.contains("/oauth/") || path.contains("/accounts/authorize") || path.contains("/auth/callback") {
            return true
        }
        let transientQueryNames = Set(["code", "state", "oauth_token", "access_token"])
        return URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?.contains {
            transientQueryNames.contains($0.name.lowercased())
        } == true
    }
}
