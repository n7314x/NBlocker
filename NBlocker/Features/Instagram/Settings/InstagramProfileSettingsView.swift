import SwiftUI

struct InstagramProfileSettingsView: View {
    @Binding var settings: InstagramSettings

    var body: some View {
        NBCard {
            VStack(alignment: .leading, spacing: NBSpacing.small) {
                NBSectionHeader(title: "Profiles")
                NBToggleRow(title: "Allow profiles", detail: "Profile route controls are planned", isOn: $settings.allowProfiles)
                    .disabled(true)
                Divider().overlay(NBColor.border)
                NBToggleRow(title: "Hide like counts", detail: "Waiting for a resilient semantic rule", isOn: $settings.hideLikeCounts)
                    .disabled(true)
            }
        }
    }
}
