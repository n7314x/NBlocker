import Foundation

struct InstagramRuleProvider: Sendable {
    func rules(for settings: InstagramSettings) -> [DOMRule] {
        guard settings.filteringEnabled else { return [] }

        var rules = [
            DOMRule(id: "instagram.bootstrap", platform: .instagram, relativePath: "Instagram/bootstrap.js", injectionTime: .documentStart),
            DOMRule(id: "instagram.navigation", platform: .instagram, relativePath: "Instagram/navigation.js", injectionTime: .documentStart),
            DOMRule(id: "instagram.style", platform: .instagram, relativePath: "Instagram/instagram.css", kind: .style, injectionTime: .documentStart)
        ]
        if settings.hideReelsTab || settings.hideReelsInFeed || settings.hideReelsOnProfiles ||
            settings.disableReelAutoplay || settings.muteReelMedia {
            rules.append(DOMRule(id: "instagram.reels.entries", platform: .instagram, relativePath: "Instagram/reels.js"))
        }
        if settings.hideExplore {
            rules.append(DOMRule(id: "instagram.explore.entries", platform: .instagram, relativePath: "Instagram/explore.js"))
        }
        if settings.hideSuggestedPosts || settings.hideSponsoredPosts || settings.hideRecommendedAccounts {
            rules.append(DOMRule(id: "instagram.feed.suggestions", platform: .instagram, relativePath: "Instagram/suggested-posts.js"))
        }
        if settings.hideFeed {
            rules.append(DOMRule(id: "instagram.feed.hidden", platform: .instagram, relativePath: "Instagram/feed.js"))
        }
        if settings.messagesOnly {
            rules.append(DOMRule(id: "instagram.messages.only", platform: .instagram, relativePath: "Instagram/messages.js"))
        }
        if settings.hideStories {
            rules.append(DOMRule(id: "instagram.stories.entries", platform: .instagram, relativePath: "Instagram/stories.js"))
        }
        if settings.grayscale || settings.grayscaleMediaOnly {
            rules.append(DOMRule(id: "instagram.appearance.grayscale", platform: .instagram, relativePath: "Instagram/grayscale.js"))
        }
        return rules
    }
}
