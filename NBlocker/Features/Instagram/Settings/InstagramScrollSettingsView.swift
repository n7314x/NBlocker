import SwiftUI

struct InstagramScrollSettingsView: View {
    @Binding var settings: InstagramSettings

    private var hasTimeReminder: Binding<Bool> {
        Binding(
            get: { settings.scrollReminderMinutes != nil },
            set: { settings.scrollReminderMinutes = $0 ? (settings.scrollReminderMinutes ?? 10) : nil }
        )
    }

    private var hasPostReminder: Binding<Bool> {
        Binding(
            get: { settings.scrollReminderPosts != nil },
            set: { settings.scrollReminderPosts = $0 ? (settings.scrollReminderPosts ?? 20) : nil }
        )
    }

    var body: some View {
        InstagramSettingsCard {
            VStack(alignment: .leading, spacing: NBSpacing.medium) {
                NBSectionHeader(title: "Scroll Control", subtitle: "Gentle reminders inside this browser session")
                NBToggleRow(title: "Time reminder", isOn: hasTimeReminder)
                Stepper(
                    "Reminder after \(settings.scrollReminderMinutes ?? 10) minutes",
                    value: Binding(
                        get: { settings.scrollReminderMinutes ?? 10 },
                        set: { settings.scrollReminderMinutes = $0 }
                    ),
                    in: 5...60,
                    step: 5
                )
                .disabled(settings.scrollReminderMinutes == nil)
                .padding(.vertical, NBSpacing.small)

                Divider().overlay(NBColor.border)
                NBToggleRow(title: "Post reminder", isOn: hasPostReminder)
                Stepper(
                    "Reminder after \(settings.scrollReminderPosts ?? 20) posts",
                    value: Binding(
                        get: { settings.scrollReminderPosts ?? 20 },
                        set: { settings.scrollReminderPosts = $0 }
                    ),
                    in: 10...100,
                    step: 10
                )
                .disabled(settings.scrollReminderPosts == nil)
                .padding(.top, NBSpacing.small)
            }
        }
    }
}
