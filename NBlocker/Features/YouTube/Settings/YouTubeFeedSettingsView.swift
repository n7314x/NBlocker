import SwiftUI

struct YouTubeFeedSettingsView: View {
    @Binding var settings: YouTubeSettings

    var body: some View {
        NBCard {
            VStack(alignment: .leading, spacing: NBSpacing.small) {
                NBSectionHeader(title: "Home & Recommendations")
                NBToggleRow(title: "Hide Home feed", isOn: $settings.hideHomeFeed)
                Divider().overlay(NBColor.border)
                NBToggleRow(title: "Hide Home recommendations", isOn: $settings.hideHomeRecommendations)
                Divider().overlay(NBColor.border)
                NBToggleRow(title: "Open to Subscriptions", isOn: $settings.openToSubscriptions)
                Divider().overlay(NBColor.border)
                NBToggleRow(title: "Hide related videos", isOn: $settings.hideRelatedVideos)
                Divider().overlay(NBColor.border)
                NBToggleRow(title: "Hide end-screen suggestions", isOn: $settings.hideEndScreenRecommendations)
            }
        }
    }
}
