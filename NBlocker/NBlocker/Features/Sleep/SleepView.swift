import SwiftUI

struct SleepView: View {
    @Environment(AppEnvironment.self) private var environment

    var body: some View {
        ScrollView {
            VStack(spacing: NBSpacing.large) {
                NBSectionHeader(title: "Sleep", subtitle: "Quiet routines without remote tracking")
                ZStack {
                    Circle().fill(Color.indigo.opacity(0.12)).frame(width: 190, height: 190)
                    Image(systemName: "moon.zzz.fill")
                        .font(.system(size: 74))
                        .foregroundStyle(Color.indigo.opacity(0.9))
                        .shadow(color: .indigo.opacity(0.35), radius: 30)
                }
                CurrentRoutineCard(routine: environment.routines.activeRoutine())
                NavigationLink {
                    RoutinesView()
                } label: {
                    NBCard {
                        NBSettingRow(symbol: "calendar.badge.clock", title: "Routines", subtitle: "Review schedules and filtering modes")
                    }
                }
                .buttonStyle(.plain)
                NBCard {
                    Label("Sleep scheduling uses on-device routine times. System app blocking needs provisioned Screen Time capabilities.", systemImage: "info.circle")
                        .font(.footnote)
                        .foregroundStyle(NBColor.secondaryText)
                }
            }
            .padding(NBSpacing.standard)
        }
        .navigationTitle("Sleep")
        .toolbarTitleDisplayMode(.inline)
        .accessibilityIdentifier("screen.sleep")
    }
}
