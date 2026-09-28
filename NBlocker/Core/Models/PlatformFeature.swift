import Foundation

enum PlatformFeature: String, Codable, CaseIterable, Sendable {
    case filtering
    case shortFormEntries
    case shortFormRoutes
    case explore
    case suggestions
    case messagesOnly
    case homeRecommendations
    case relatedRecommendations
    case autoplay
    case comments
    case grayscale
}
