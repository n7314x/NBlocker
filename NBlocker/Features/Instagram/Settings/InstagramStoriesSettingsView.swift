import SwiftUI

struct InstagramStoriesSettingsView: View {
    @Binding var settings: InstagramSettings

    var body: some View {
        InstagramSettingsCard {
            VStack(alignment: .leading, spacing: NBSpacing.medium) {
                NBSectionHeader(title: "Stories", subtitle: "Story filtering is conservative")
                NBToggleRow(title: "Hide Stories", isOn: $settings.hideStories)
                Divider().overlay(NBColor.border)
                NBToggleRow(title: "Hide sponsored Stories", isOn: $settings.hideStoryAds)
            }
        }
    }
}
