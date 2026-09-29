import SwiftUI

struct InstagramAppearanceSettingsView: View {
    @Binding var settings: InstagramSettings

    var body: some View {
        InstagramSettingsCard {
            VStack(alignment: .leading, spacing: NBSpacing.medium) {
                NBSectionHeader(title: "Appearance", subtitle: "Quiet the visual intensity")
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
