import Foundation

struct YouTubeRuleProvider: Sendable {
    func rules(for settings: YouTubeSettings) -> [DOMRule] {
        guard settings.filteringEnabled else { return [] }

        var rules = [
            DOMRule(id: "youtube.bootstrap", platform: .youtube, relativePath: "YouTube/bootstrap.js", injectionTime: .documentStart),
            DOMRule(id: "youtube.navigation", platform: .youtube, relativePath: "YouTube/navigation.js", injectionTime: .documentStart),
            DOMRule(id: "youtube.style", platform: .youtube, relativePath: "YouTube/youtube.css", kind: .style, injectionTime: .documentStart)
        ]
        if settings.hideShortsTab || settings.hideShortsShelves {
            rules.append(DOMRule(id: "youtube.shorts.entries", platform: .youtube, relativePath: "YouTube/shorts.js"))
        }
        if settings.hideHomeFeed || settings.hideHomeRecommendations {
            rules.append(DOMRule(id: "youtube.home.recommendations", platform: .youtube, relativePath: "YouTube/home.js"))
        }
        if settings.hideRelatedVideos || settings.hideEndScreenRecommendations {
            rules.append(DOMRule(id: "youtube.watch.recommendations", platform: .youtube, relativePath: "YouTube/recommendations.js"))
        }
        if settings.disableAutoplay {
            rules.append(DOMRule(id: "youtube.playback.autoplay", platform: .youtube, relativePath: "YouTube/autoplay.js"))
        }
        if settings.hideSearchSuggestions {
            rules.append(DOMRule(id: "youtube.search.suggestions", platform: .youtube, relativePath: "YouTube/search.js"))
        }
        if !settings.showComments {
            rules.append(DOMRule(id: "youtube.comments.hidden", platform: .youtube, relativePath: "YouTube/comments.js"))
        }
        if settings.grayscale || settings.hideThumbnails {
            rules.append(DOMRule(id: "youtube.appearance.grayscale", platform: .youtube, relativePath: "YouTube/grayscale.js"))
        }
        return rules
    }
}
