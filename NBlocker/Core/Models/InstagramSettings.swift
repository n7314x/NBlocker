import Foundation

struct InstagramSettings: Codable, Equatable, Sendable {
    var filteringEnabled = true
    var hideFeed = false
    var hideSuggestedPosts = true
    var hideSponsoredPosts = true
    var hideRecommendedAccounts = true
    var hideReelsTab = true
    var hideReelsInFeed = true
    var hideReelsOnProfiles = true
    var blockReelRoutes = true
    var allowSharedReel = false
    var blockReelChaining = true
    var disableReelAutoplay = true
    var muteReelMedia = false
    var hideStories = false
    var hideStoryAds = true
    var hideExplore = true
    var allowAccountSearch = true
    var blockPostSearch = false
    var messagesOnly = false
    var openToInbox = false
    var allowSharedMedia = true
    var allowProfiles = true
    var hideLikeCounts = false
    var grayscale = false
    var grayscaleMediaOnly = false
    var reduceWebMotion = true
    var scrollReminderMinutes: Int? = 10
    var scrollReminderPosts: Int?

    init() {}

    private enum CodingKeys: String, CodingKey {
        case filteringEnabled, hideFeed, hideSuggestedPosts, hideSponsoredPosts
        case hideRecommendedAccounts, hideReelsTab, hideReelsInFeed, hideReelsOnProfiles
        case blockReelRoutes, allowSharedReel, blockReelChaining, disableReelAutoplay
        case muteReelMedia, hideStories, hideStoryAds, hideExplore, allowAccountSearch, blockPostSearch
        case messagesOnly, openToInbox, allowSharedMedia, allowProfiles, hideLikeCounts
        case grayscale, grayscaleMediaOnly, reduceWebMotion
        case scrollReminderMinutes, scrollReminderPosts
    }

    init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        filteringEnabled = values.decode(Bool.self, forKey: .filteringEnabled, default: true)
        hideFeed = values.decode(Bool.self, forKey: .hideFeed, default: false)
        hideSuggestedPosts = values.decode(Bool.self, forKey: .hideSuggestedPosts, default: true)
        hideSponsoredPosts = values.decode(Bool.self, forKey: .hideSponsoredPosts, default: true)
        hideRecommendedAccounts = values.decode(Bool.self, forKey: .hideRecommendedAccounts, default: true)
        hideReelsTab = values.decode(Bool.self, forKey: .hideReelsTab, default: true)
        hideReelsInFeed = values.decode(Bool.self, forKey: .hideReelsInFeed, default: true)
        hideReelsOnProfiles = values.decode(Bool.self, forKey: .hideReelsOnProfiles, default: true)
        blockReelRoutes = values.decode(Bool.self, forKey: .blockReelRoutes, default: true)
        allowSharedReel = values.decode(Bool.self, forKey: .allowSharedReel, default: false)
        blockReelChaining = values.decode(Bool.self, forKey: .blockReelChaining, default: true)
        disableReelAutoplay = values.decode(Bool.self, forKey: .disableReelAutoplay, default: true)
        muteReelMedia = values.decode(Bool.self, forKey: .muteReelMedia, default: false)
        hideStories = values.decode(Bool.self, forKey: .hideStories, default: false)
        hideStoryAds = values.decode(Bool.self, forKey: .hideStoryAds, default: true)
        hideExplore = values.decode(Bool.self, forKey: .hideExplore, default: true)
        allowAccountSearch = values.decode(Bool.self, forKey: .allowAccountSearch, default: true)
        blockPostSearch = values.decode(Bool.self, forKey: .blockPostSearch, default: false)
        messagesOnly = values.decode(Bool.self, forKey: .messagesOnly, default: false)
        openToInbox = values.decode(Bool.self, forKey: .openToInbox, default: false)
        allowSharedMedia = values.decode(Bool.self, forKey: .allowSharedMedia, default: true)
        allowProfiles = values.decode(Bool.self, forKey: .allowProfiles, default: true)
        hideLikeCounts = values.decode(Bool.self, forKey: .hideLikeCounts, default: false)
        grayscale = values.decode(Bool.self, forKey: .grayscale, default: false)
        grayscaleMediaOnly = values.decode(Bool.self, forKey: .grayscaleMediaOnly, default: false)
        reduceWebMotion = values.decode(Bool.self, forKey: .reduceWebMotion, default: true)
        if values.contains(.scrollReminderMinutes) {
            scrollReminderMinutes = try values.decodeIfPresent(Int.self, forKey: .scrollReminderMinutes)
        } else {
            scrollReminderMinutes = 10
        }
        scrollReminderPosts = try values.decodeIfPresent(Int.self, forKey: .scrollReminderPosts)
    }

    static let `default` = InstagramSettings()
}
