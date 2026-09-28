import SwiftUI

struct SleepView: View {
    @Environment(AppEnvironment.self) private var environment

    var body: some View {
        ScrollView {
            VStack(spacing: NBSpacing.large) {
                Text("Quiet routines without remote tracking.")
                    .font(.footnote)
                    .foregroundStyle(NBColor.secondaryText)
                    .frame(maxWidth: .infinity, alignment: .leading)

                ZStack {
                    Circle()
                        .fill(Color.indigo.opacity(0.12))
                        .frame(width: 170, height: 170)

                    Image(systemName: "moon.zzz.fill")
                        .font(.system(size: 68))
                        .foregroundStyle(Color.indigo.opacity(0.9))
                        .shadow(color: .indigo.opacity(0.32), radius: 26)
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
                    .font(.footnote)
                    .foregroundStyle(NBColor.secondaryText)
                }
            }
            .padding(.horizontal, NBSpacing.standard)
            .padding(.top, NBSpacing.medium)
            .padding(.bottom, NBSpacing.large)
        }
        .scrollIndicators(.hidden)
        .navigationTitle("Sleep")
        .toolbarTitleDisplayMode(.inline)
        .accessibilityIdentifier("screen.sleep")
    }
}
