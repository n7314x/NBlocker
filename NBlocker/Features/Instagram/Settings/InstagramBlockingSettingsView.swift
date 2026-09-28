import SwiftUI

struct InstagramBlockingSettingsView: View {
    @Binding var settings: InstagramSettings

    var body: some View {
        NBCard {
            VStack(alignment: .leading, spacing: NBSpacing.small) {
                NBSectionHeader(title: "Blocking", subtitle: "Master switch and route policy")
                NBToggleRow(title: "Enable filtering", detail: "Applies the selected page rules", isOn: $settings.filteringEnabled)
                Divider().overlay(NBColor.border)
                NBToggleRow(title: "Block all Reel URLs", detail: "Cancels matching navigation before the page loads", isOn: $settings.blockReelRoutes)
            }
        }
    }
}
