import SwiftUI

struct YouTubeCommentsSettingsView: View {
    @Binding var settings: YouTubeSettings

    var body: some View {
        NBCard {
            VStack(alignment: .leading, spacing: NBSpacing.small) {
                NBSectionHeader(title: "Comments")
                NBToggleRow(title: "Show comments", isOn: $settings.showComments)
            }
        }
    }
}
