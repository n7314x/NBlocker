import SwiftUI

struct InstagramMessagesSettingsView: View {
    @Binding var settings: InstagramSettings

    var body: some View {
        InstagramSettingsSection("Messages", subtitle: "Keep direct communication available") {
            VStack(alignment: .leading, spacing: 0) {
                NBToggleRow(title: "DMs-only mode", detail: "Suppresses distracting navigation while in messages", isOn: $settings.messagesOnly)
                Divider().overlay(NBColor.border)
                NBToggleRow(title: "Open directly to inbox", isOn: $settings.openToInbox)
                Divider().overlay(NBColor.border)
                NBToggleRow(title: "Allow shared media", detail: "Planned for Single Reel mode", isOn: $settings.allowSharedMedia)
                    .disabled(true)
            }
        }
    }
}
