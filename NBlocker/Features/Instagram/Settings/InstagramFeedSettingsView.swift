import SwiftUI

struct InstagramFeedSettingsView: View {
    @Binding var settings: InstagramSettings

    var body: some View {
        InstagramSettingsSection("Feed", subtitle: "Reduce algorithmic inserts") {
            VStack(alignment: .leading, spacing: 0) {
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
