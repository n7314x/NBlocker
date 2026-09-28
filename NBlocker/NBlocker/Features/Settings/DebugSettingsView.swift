import SwiftUI

struct DebugSettingsView: View {
    @Environment(AppEnvironment.self) private var environment
    @State private var confirmsClear = false

    var body: some View {
        List {
            Section("Data") {
                Button("Clear local usage", role: .destructive) { confirmsClear = true }
                Button("Reset platform settings", role: .destructive) { environment.settings.reset() }
            }
            Section("Diagnostics") {
                LabeledContent("Stored sessions", value: "\(environment.usage.sessions.count)")
                LabeledContent("Screen Time", value: environment.screenTime.state.title)
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.black)
        .navigationTitle("Data & Debug")
        .confirmationDialog("Clear local usage history?", isPresented: $confirmsClear) {
            Button("Clear Usage", role: .destructive) { environment.usage.clear() }
        }
    }
}
