import SwiftUI

struct NotificationSettingsView: View {
    @State private var routineReminders = false

    var body: some View {
        List {
            Toggle("Routine reminders", isOn: $routineReminders)
                .disabled(true)
            Text("Routine notification scheduling is planned. This build does not request notification permission.")
                .font(.footnote)
                .foregroundStyle(NBColor.secondaryText)
        }
        .scrollContentBackground(.hidden)
        .background(Color.black)
        .navigationTitle("Notifications")
    }
}
