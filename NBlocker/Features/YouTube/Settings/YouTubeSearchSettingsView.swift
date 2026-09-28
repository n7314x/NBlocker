import SwiftUI

struct YouTubeSearchSettingsView: View {
    @Binding var settings: YouTubeSettings

    var body: some View {
        NBCard {
            VStack(alignment: .leading, spacing: NBSpacing.small) {
                NBSectionHeader(title: "Search & Subscriptions")
                NBToggleRow(title: "Allow normal search", isOn: $settings.allowSearch)
                Divider().overlay(NBColor.border)
                NBToggleRow(title: "Hide search suggestions", isOn: $settings.hideSearchSuggestions)
            }
        }
    }
}
