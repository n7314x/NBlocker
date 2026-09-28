import SwiftUI

struct YouTubePlaybackSettingsView: View {
    @Binding var settings: YouTubeSettings

    var body: some View {
        NBCard {
            VStack(alignment: .leading, spacing: NBSpacing.small) {
                NBSectionHeader(title: "Playback", subtitle: "Normal long-form playback remains available")
                NBToggleRow(title: "Disable autoplay", detail: "Best effort within the website player", isOn: $settings.disableAutoplay)
                Text("Picture in Picture and background audio depend on WebKit, iOS, and YouTube behavior.")
                    .font(.caption)
                    .foregroundStyle(NBColor.quietText)
            }
        }
    }
}
