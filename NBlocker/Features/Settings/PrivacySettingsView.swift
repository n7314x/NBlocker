import SwiftUI

struct PrivacySettingsView: View {
    var body: some View {
        List {
            Label("No NBlocker account", systemImage: "person.crop.circle.badge.xmark")
            Label("No analytics or telemetry", systemImage: "waveform.path.ecg.rectangle")
            Label("Website login remains in WebKit", systemImage: "lock.shield")
            Text("NBlocker stores preferences, routines, and aggregate app-contained usage locally.")
                .font(.footnote)
                .foregroundStyle(NBColor.secondaryText)
        }
        .scrollContentBackground(.hidden)
        .background(Color.black)
        .navigationTitle("Privacy")
    }
}
