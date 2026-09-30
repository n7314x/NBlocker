import SwiftUI

struct InstagramBlockingSettingsView: View {
    @Binding var settings: InstagramSettings

    var body: some View {
        InstagramSettingsSection("Filtering", subtitle: "Choose when NBlocker applies your rules") {
            VStack(alignment: .leading, spacing: 0) {
                NBToggleRow(title: "Enable filtering", detail: "Applies the selected page rules", isOn: $settings.filteringEnabled)
                Divider().overlay(NBColor.border)
                NBToggleRow(title: "Block all Reel URLs", detail: "Cancels matching navigation before the page loads", isOn: $settings.blockReelRoutes)
            }
        }
    }
}
