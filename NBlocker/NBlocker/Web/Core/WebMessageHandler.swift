import Foundation

enum WebBridgeEvent: Equatable, Sendable {
    case ruleError(identifier: String)
    case navigationPrevented(route: ShortFormRoute)
    case scroll(direction: ScrollDirection)

    enum ScrollDirection: String, Sendable {
        case up, down
    }

    enum ShortFormRoute: String, Sendable {
        case reel, short
    }
}

enum WebMessageHandler {
    private static let allowedRuleIdentifiers: Set<String> = [
        "instagram.navigation",
        "instagram.reels.entries",
        "instagram.explore.entries",
        "instagram.feed.suggestions",
        "instagram.feed.hidden",
        "instagram.messages.only",
        "instagram.stories.entries",
        "instagram.appearance.grayscale",
        "youtube.navigation",
        "youtube.shorts.entries",
        "youtube.home.recommendations",
        "youtube.watch.recommendations",
        "youtube.playback.autoplay",
        "youtube.search.suggestions",
        "youtube.comments.hidden",
        "youtube.appearance.grayscale"
    ]

    static func event(from body: Any) -> WebBridgeEvent? {
        guard
            let payload = body as? [String: Any],
            let name = payload["event"] as? String
        else { return nil }

        switch name {
        case "ruleError":
            let candidate = payload["rule"] as? String
            let identifier = candidate.flatMap { allowedRuleIdentifiers.contains($0) ? $0 : nil } ?? "unknown"
            return .ruleError(identifier: identifier)
        case "navigationPrevented":
            guard
                let rawRoute = payload["route"] as? String,
                let route = WebBridgeEvent.ShortFormRoute(rawValue: rawRoute)
            else { return nil }
            return .navigationPrevented(route: route)
        case "scroll":
            guard
                let rawDirection = payload["direction"] as? String,
                let direction = WebBridgeEvent.ScrollDirection(rawValue: rawDirection)
            else { return nil }
            return .scroll(direction: direction)
        default:
            return nil
        }
    }
}
