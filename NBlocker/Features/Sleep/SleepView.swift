import SwiftUI

struct SleepView: View {
    @Environment(AppEnvironment.self) private var environment

    var body: some View {
        NBRootScrollView {
            NBSectionHeader(title: "Sleep", subtitle: "Quiet routines without remote tracking")

            ZStack {
                Circle()
                    .fill(Color.indigo.opacity(0.12))
                    .frame(width: 92, height: 92)
                    .allowsHitTesting(false)

                Image(systemName: "moon.zzz.fill")
                    .font(.system(size: 36))
                    .foregroundStyle(Color.indigo.opacity(0.9))
                    .shadow(color: .indigo.opacity(0.24), radius: 12)
            }
            .frame(maxWidth: .infinity)

            CurrentRoutineCard(routine: environment.routines.activeRoutine())

            NavigationLink {
                RoutinesView()
            } label: {
                NBCard {
                    NBSettingRow(
                        symbol: "calendar.badge.clock",
                        title: "Routines",
                        subtitle: "Review schedules and filtering modes"
                    )
                }
            }
            .buttonStyle(.plain)

            NBCard {
                Label(
                    "Sleep scheduling uses on-device routine times. System app blocking needs provisioned Screen Time capabilities.",
                    systemImage: "info.circle"
                )
                .font(.caption2)
                .foregroundStyle(NBColor.secondaryText)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .accessibilityIdentifier("screen.sleep")
    }
}
