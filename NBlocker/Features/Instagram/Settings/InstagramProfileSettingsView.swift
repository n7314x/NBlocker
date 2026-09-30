import SwiftUI

struct InstagramProfileSettingsView: View {
    @Binding var settings: InstagramSettings

    var body: some View {
        InstagramSettingsSection("Profiles", subtitle: "Controls being prepared for resilient filtering") {
            VStack(alignment: .leading, spacing: 0) {
                NBToggleRow(title: "Allow profiles", detail: "Profile route controls are planned", isOn: $settings.allowProfiles)
                    .disabled(true)
                Divider().overlay(NBColor.border)
                NBToggleRow(title: "Hide like counts", detail: "Waiting for a resilient semantic rule", isOn: $settings.hideLikeCounts)
                    .disabled(true)
            }
        }
    }
}
