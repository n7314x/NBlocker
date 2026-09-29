import Foundation

enum WebBridgeEvent: Equatable, Sendable {
    case ruleError(identifier: String)
    case navigationPrevented(route: ShortFormRoute)
    case scroll(direction: ScrollDirection)
    case metrics(ads: Int, suggested: Int, blockable: Int)
    case scrollReminder(kind: ReminderKind)

    enum ScrollDirection: String, Sendable {
        case up, down
    }

    enum ShortFormRoute: String, Sendable {
        case reel, short
    }

    enum ReminderKind: String, Sendable {
        case time, posts
    }
}

enum WebMessageHandler {
    private static let allowedRuleIdentifiers: Set<String> = [
        "instagram.navigation",
        "instagram.reels.entries",
        "instagram.explore.entries",
        "instagram.feed.suggestions",
        "instagram.feed.hidden",
        "instagram.feed.ads",
        "instagram.messages.only",
        "instagram.search.results",
        "instagram.stories.entries",
        "instagram.scroll.reminders",
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
        case "metrics":
            guard
                let ads = safeCount(payload["ads"]),
                let suggested = safeCount(payload["suggested"]),
                let blockable = safeCount(payload["blockable"])
            else { return nil }
            return .metrics(ads: ads, suggested: suggested, blockable: blockable)
        case "scrollReminder":
            guard
                let rawKind = payload["kind"] as? String,
                let kind = WebBridgeEvent.ReminderKind(rawValue: rawKind)
            else { return nil }
            return .scrollReminder(kind: kind)
        default:
            return nil
        }
    }

    private static func safeCount(_ value: Any?) -> Int? {
        guard !(value is Bool), let number = value as? NSNumber else {
            return nil
        }
        let count = number.intValue
        guard count >= 0 else { return nil }
        return min(count, 9_999)
    }
}
