import SwiftUI

struct InstagramScrollSettingsView: View {
    @Binding var settings: InstagramSettings

    var body: some View {
        NBCard {
            VStack(alignment: .leading, spacing: NBSpacing.medium) {
                NBSectionHeader(title: "Scroll Control", subtitle: "Time reminders are planned for the next milestone")
                Stepper(
                    "Reminder after \(settings.scrollReminderMinutes ?? 10) minutes",
                    value: Binding(
                        get: { settings.scrollReminderMinutes ?? 10 },
                        set: { settings.scrollReminderMinutes = $0 }
                    ),
                    in: 5...60,
                    step: 5
                )
                .disabled(true)
            }
        }
    }
}
