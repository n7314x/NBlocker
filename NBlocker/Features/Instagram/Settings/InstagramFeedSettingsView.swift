import SwiftUI

struct InstagramFeedSettingsView: View {
    @Binding var settings: InstagramSettings

    var body: some View {
        InstagramSettingsCard {
            VStack(alignment: .leading, spacing: NBSpacing.medium) {
                NBSectionHeader(title: "Feed", subtitle: "Reduce algorithmic inserts")
                NBToggleRow(title: "Hide feed", isOn: $settings.hideFeed)
                Divider().overlay(NBColor.border)
                NBToggleRow(title: "Hide suggested posts", isOn: $settings.hideSuggestedPosts)
                Divider().overlay(NBColor.border)
                NBToggleRow(title: "Hide sponsored posts", isOn: $settings.hideSponsoredPosts)
                Divider().overlay(NBColor.border)
                NBToggleRow(title: "Hide recommended accounts", isOn: $settings.hideRecommendedAccounts)
            }
        }
    }
}
