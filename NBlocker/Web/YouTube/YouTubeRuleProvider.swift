import Foundation

struct YouTubeRuleProvider: Sendable {
    func rules(for _: YouTubeSettings) -> [DOMRule] {
        return [
            DOMRule(id: "youtube.bootstrap", platform: .youtube, relativePath: "YouTube/bootstrap.js", injectionTime: .documentStart),
            DOMRule(id: "youtube.navigation", platform: .youtube, relativePath: "YouTube/navigation.js", injectionTime: .documentStart),
            DOMRule(id: "youtube.style", platform: .youtube, relativePath: "YouTube/youtube.css", kind: .style, injectionTime: .documentStart),
            DOMRule(id: "youtube.shorts.entries", platform: .youtube, relativePath: "YouTube/shorts.js"),
            DOMRule(id: "youtube.home.recommendations", platform: .youtube, relativePath: "YouTube/home.js"),
            DOMRule(id: "youtube.watch.recommendations", platform: .youtube, relativePath: "YouTube/recommendations.js"),
            DOMRule(id: "youtube.playback.autoplay", platform: .youtube, relativePath: "YouTube/autoplay.js"),
            DOMRule(id: "youtube.search.suggestions", platform: .youtube, relativePath: "YouTube/search.js"),
            DOMRule(id: "youtube.comments.hidden", platform: .youtube, relativePath: "YouTube/comments.js"),
            DOMRule(id: "youtube.appearance.grayscale", platform: .youtube, relativePath: "YouTube/grayscale.js")
        ]
    }
}
