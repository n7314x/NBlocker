import SwiftUI

struct YouTubeAppearanceSettingsView: View {
    @Binding var settings: YouTubeSettings

    var body: some View {
        NBCard {
            VStack(alignment: .leading, spacing: NBSpacing.small) {
                NBSectionHeader(title: "Appearance")
                NBToggleRow(title: "Grayscale website", isOn: $settings.grayscale)
                Divider().overlay(NBColor.border)
                NBToggleRow(title: "Hide thumbnails", detail: "Experimental; may make browsing harder", isOn: $settings.hideThumbnails)
                Divider().overlay(NBColor.border)
                NBToggleRow(title: "Reduce website motion", isOn: $settings.reduceWebMotion)
            }
        }
    }
}
