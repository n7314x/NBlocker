import SwiftUI

struct InstagramBlockingSettingsView: View {
    @Binding var settings: InstagramSettings

    var body: some View {
        InstagramSettingsCard {
            VStack(alignment: .leading, spacing: NBSpacing.medium) {
                NBSectionHeader(title: "Filtering", subtitle: "Choose when NBlocker applies your rules")
                NBToggleRow(title: "Enable filtering", detail: "Applies the selected page rules", isOn: $settings.filteringEnabled)
                Divider().overlay(NBColor.border)
                NBToggleRow(title: "Block all Reel URLs", detail: "Cancels matching navigation before the page loads", isOn: $settings.blockReelRoutes)
            }
        }
    }
}
