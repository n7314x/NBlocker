import Foundation

struct YouTubeSettings: Codable, Equatable, Sendable {
    var filteringEnabled = true
    var hideShortsTab = true
    var hideShortsShelves = true
    var blockShortRoutes = true
    var allowSharedShort = false
    var preventShortChaining = true
    var hideHomeFeed = false
    var hideHomeRecommendations = true
    var openToSubscriptions = false
    var hideRelatedVideos = true
    var hideEndScreenRecommendations = true
    var disableAutoplay = true
    var allowSearch = true
    var hideSearchSuggestions = false
    var showComments = true
    var grayscale = false
    var hideThumbnails = false
    var reduceWebMotion = true

    init() {}

    private enum CodingKeys: String, CodingKey {
        case filteringEnabled, hideShortsTab, hideShortsShelves, blockShortRoutes
        case allowSharedShort, preventShortChaining, hideHomeFeed, hideHomeRecommendations
        case openToSubscriptions, hideRelatedVideos, hideEndScreenRecommendations
        case disableAutoplay, allowSearch, hideSearchSuggestions, showComments
        case grayscale, hideThumbnails, reduceWebMotion
    }

    init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        filteringEnabled = values.decode(Bool.self, forKey: .filteringEnabled, default: true)
        hideShortsTab = values.decode(Bool.self, forKey: .hideShortsTab, default: true)
        hideShortsShelves = values.decode(Bool.self, forKey: .hideShortsShelves, default: true)
        blockShortRoutes = values.decode(Bool.self, forKey: .blockShortRoutes, default: true)
        allowSharedShort = values.decode(Bool.self, forKey: .allowSharedShort, default: false)
        preventShortChaining = values.decode(Bool.self, forKey: .preventShortChaining, default: true)
        hideHomeFeed = values.decode(Bool.self, forKey: .hideHomeFeed, default: false)
        hideHomeRecommendations = values.decode(Bool.self, forKey: .hideHomeRecommendations, default: true)
        openToSubscriptions = values.decode(Bool.self, forKey: .openToSubscriptions, default: false)
        hideRelatedVideos = values.decode(Bool.self, forKey: .hideRelatedVideos, default: true)
        hideEndScreenRecommendations = values.decode(Bool.self, forKey: .hideEndScreenRecommendations, default: true)
        disableAutoplay = values.decode(Bool.self, forKey: .disableAutoplay, default: true)
        allowSearch = values.decode(Bool.self, forKey: .allowSearch, default: true)
        hideSearchSuggestions = values.decode(Bool.self, forKey: .hideSearchSuggestions, default: false)
        showComments = values.decode(Bool.self, forKey: .showComments, default: true)
        grayscale = values.decode(Bool.self, forKey: .grayscale, default: false)
        hideThumbnails = values.decode(Bool.self, forKey: .hideThumbnails, default: false)
        reduceWebMotion = values.decode(Bool.self, forKey: .reduceWebMotion, default: true)
    }

    static let `default` = YouTubeSettings()
}
