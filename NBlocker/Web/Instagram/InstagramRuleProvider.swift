import Foundation

struct InstagramRuleProvider: Sendable {
    func rules(for _: InstagramSettings) -> [DOMRule] {
        return [
            DOMRule(id: "instagram.bootstrap", platform: .instagram, relativePath: "Instagram/bootstrap.js", injectionTime: .documentStart),
            DOMRule(id: "instagram.navigation", platform: .instagram, relativePath: "Instagram/navigation.js", injectionTime: .documentStart),
            DOMRule(id: "instagram.style", platform: .instagram, relativePath: "Instagram/instagram.css", kind: .style, injectionTime: .documentStart),
            DOMRule(id: "instagram.reels.entries", platform: .instagram, relativePath: "Instagram/reels.js"),
            DOMRule(id: "instagram.explore.entries", platform: .instagram, relativePath: "Instagram/explore.js"),
            DOMRule(id: "instagram.feed.suggestions", platform: .instagram, relativePath: "Instagram/suggested-posts.js"),
            DOMRule(id: "instagram.feed.ads", platform: .instagram, relativePath: "Instagram/ads.js"),
            DOMRule(id: "instagram.feed.hidden", platform: .instagram, relativePath: "Instagram/feed.js"),
            DOMRule(id: "instagram.messages.only", platform: .instagram, relativePath: "Instagram/messages.js"),
            DOMRule(id: "instagram.stories.entries", platform: .instagram, relativePath: "Instagram/stories.js"),
            DOMRule(id: "instagram.search.results", platform: .instagram, relativePath: "Instagram/search.js"),
            DOMRule(id: "instagram.appearance.grayscale", platform: .instagram, relativePath: "Instagram/grayscale.js"),
            DOMRule(id: "instagram.scroll.reminders", platform: .instagram, relativePath: "Instagram/scroll-reminders.js")
        ]
    }
}
