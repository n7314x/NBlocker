import SwiftUI

struct InstagramAppearanceSettingsView: View {
    @Binding var settings: InstagramSettings

    var body: some View {
        InstagramSettingsSection("Appearance", subtitle: "Quiet the visual intensity") {
            VStack(alignment: .leading, spacing: 0) {
                NBToggleRow(title: "Grayscale website", isOn: $settings.grayscale)
                Divider().overlay(NBColor.border)
                NBToggleRow(title: "Grayscale media only", isOn: $settings.grayscaleMediaOnly)
                    .disabled(settings.grayscale)
                Divider().overlay(NBColor.border)
                NBToggleRow(title: "Reduce website motion", isOn: $settings.reduceWebMotion)
            }
        }
    }
}
