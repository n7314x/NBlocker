import SwiftUI

struct InstagramProfileSettingsView: View {
    @Binding var settings: InstagramSettings

    var body: some View {
        InstagramSettingsCard {
            VStack(alignment: .leading, spacing: NBSpacing.medium) {
                NBSectionHeader(title: "Profiles", subtitle: "Controls being prepared for resilient filtering")
                NBToggleRow(title: "Allow profiles", detail: "Profile route controls are planned", isOn: $settings.allowProfiles)
                    .disabled(true)
                Divider().overlay(NBColor.border)
                NBToggleRow(title: "Hide like counts", detail: "Waiting for a resilient semantic rule", isOn: $settings.hideLikeCounts)
                    .disabled(true)
            }
        }
    }
}
