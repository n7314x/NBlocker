import SwiftUI

struct InstagramStoriesSettingsView: View {
    @Binding var settings: InstagramSettings

    var body: some View {
        InstagramSettingsSection("Stories", subtitle: "Story filtering is conservative") {
            VStack(alignment: .leading, spacing: 0) {
                NBToggleRow(title: "Hide Stories", isOn: $settings.hideStories)
                Divider().overlay(NBColor.border)
                NBToggleRow(title: "Hide sponsored Stories", isOn: $settings.hideStoryAds)
            }
        }
    }
}
