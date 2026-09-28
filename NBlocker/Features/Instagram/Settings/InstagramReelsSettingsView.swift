import SwiftUI

struct InstagramReelsSettingsView: View {
    @Binding var settings: InstagramSettings

    var body: some View {
        NBCard {
            VStack(alignment: .leading, spacing: NBSpacing.small) {
                NBSectionHeader(title: "Reels", subtitle: "Limit short-form loops")
                NBToggleRow(title: "Hide Reels tab", isOn: $settings.hideReelsTab)
                Divider().overlay(NBColor.border)
                NBToggleRow(title: "Hide Reels in feed", isOn: $settings.hideReelsInFeed)
                Divider().overlay(NBColor.border)
                NBToggleRow(title: "Hide Reels on profiles", isOn: $settings.hideReelsOnProfiles)
                Divider().overlay(NBColor.border)
                NBToggleRow(title: "Prevent next Reel", detail: "Best-effort navigation filtering", isOn: $settings.blockReelChaining)
                Divider().overlay(NBColor.border)
                NBToggleRow(title: "Disable autoplay", isOn: $settings.disableReelAutoplay)
                Divider().overlay(NBColor.border)
                NBToggleRow(title: "Mute Reel media", isOn: $settings.muteReelMedia)
            }
        }
    }
}
