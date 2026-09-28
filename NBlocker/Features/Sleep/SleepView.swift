import SwiftUI

struct SleepView: View {
    @Environment(AppEnvironment.self) private var environment

    var body: some View {
        ScrollView {
            VStack(spacing: NBSpacing.medium) {
                NBSectionHeader(title: "Sleep", subtitle: "Quiet routines without remote tracking")

                ZStack {
                    Circle()
                        .fill(Color.indigo.opacity(0.12))
                        .frame(width: 118, height: 118)

                    Image(systemName: "moon.zzz.fill")
                        .font(.system(size: 48))
                        .foregroundStyle(Color.indigo.opacity(0.9))
                        .shadow(color: .indigo.opacity(0.28), radius: 18)
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
            .padding(.horizontal, NBSpacing.standard)
            .padding(.top, NBSpacing.small)
            .padding(.bottom, NBSpacing.medium)
        }
        .scrollIndicators(.hidden)
        .toolbar(.hidden, for: .navigationBar)
        .accessibilityIdentifier("screen.sleep")
    }
}
