import SwiftUI

struct InstagramSearchSettingsView: View {
    @Binding var settings: InstagramSettings

    var body: some View {
        NBCard {
            VStack(alignment: .leading, spacing: NBSpacing.small) {
                NBSectionHeader(title: "Explore & Search")
                NBToggleRow(title: "Hide Explore", isOn: $settings.hideExplore)
                Divider().overlay(NBColor.border)
                NBToggleRow(title: "Allow account search", detail: "Independent result filtering is planned", isOn: $settings.allowAccountSearch)
                    .disabled(true)
                Divider().overlay(NBColor.border)
                NBToggleRow(title: "Block post search", detail: "Independent result filtering is planned", isOn: $settings.blockPostSearch)
                    .disabled(true)
            }
        }
    }
}
