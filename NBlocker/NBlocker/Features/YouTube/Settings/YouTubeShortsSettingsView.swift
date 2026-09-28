import SwiftUI

struct YouTubeShortsSettingsView: View {
    @Binding var settings: YouTubeSettings

    var body: some View {
        NBCard {
            VStack(alignment: .leading, spacing: NBSpacing.small) {
                NBSectionHeader(title: "Shorts", subtitle: "Limit short-form loops")
                NBToggleRow(title: "Hide Shorts tab", isOn: $settings.hideShortsTab)
                Divider().overlay(NBColor.border)
                NBToggleRow(title: "Hide Shorts shelves", isOn: $settings.hideShortsShelves)
                Divider().overlay(NBColor.border)
                NBToggleRow(title: "Block Shorts URLs", detail: "Cancels /shorts/ navigation before loading", isOn: $settings.blockShortRoutes)
                Divider().overlay(NBColor.border)
                NBToggleRow(title: "Prevent next Short", detail: "Best-effort navigation filtering", isOn: $settings.preventShortChaining)
            }
        }
    }
}
