import SwiftUI

struct InstagramSearchSettingsView: View {
    @Binding var settings: InstagramSettings

    var body: some View {
        InstagramSettingsSection("Explore & Search", subtitle: "Keep discovery deliberate") {
            VStack(alignment: .leading, spacing: 0) {
                NBToggleRow(title: "Hide Explore", isOn: $settings.hideExplore)
                Divider().overlay(NBColor.border)
                NBToggleRow(title: "Allow account search", detail: "Keeps profile results available", isOn: $settings.allowAccountSearch)
                Divider().overlay(NBColor.border)
                NBToggleRow(title: "Block post search", detail: "Hides post and Reel results in Explore search", isOn: $settings.blockPostSearch)
            }
        }
    }
}
