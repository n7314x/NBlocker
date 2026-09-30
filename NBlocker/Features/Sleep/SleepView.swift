import SwiftUI

struct SleepView: View {
    @Environment(AppEnvironment.self) private var environment
    @State private var showsInfo = false

    var body: some View {
        let routine = environment.routines.activeRoutine() ?? environment.routines.routines.first

        NBRootScrollView(spacing: NBSpacing.xLarge) {
            NBScreenHeader("Sleep Mode") {
                Button {
                    showsInfo = true
                } label: {
                    Image(systemName: "questionmark.circle")
                        .font(.title2.weight(.semibold))
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.plain)
                .foregroundStyle(NBColor.secondaryText)
                .accessibilityLabel("About Sleep Mode")
            }

            sleepHero(isActive: routine?.isEnabled == true)
                .frame(maxWidth: .infinity)

            scheduleSummary(routine)

            NavigationLink {
                RoutinesView()
            } label: {
                Label("Manage Sleep Routines", systemImage: "moon.zzz.fill")
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 58)
                    .background {
                        LinearGradient(
                            colors: [.white, Color.indigo.opacity(0.72)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    }
                    .clipShape(Capsule())
            }
            .buttonStyle(NBSpringPressButtonStyle())

            CurrentRoutineCard(routine: routine)
        }
        .toolbar(.hidden, for: .navigationBar)
        .sheet(isPresented: $showsInfo) {
            SleepInfoSheet()
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
                .presentationCornerRadius(NBRadius.sheet)
                .presentationBackground(NBColor.sheet)
        }
        .accessibilityIdentifier("screen.sleep")
    }

    private func sleepHero(isActive: Bool) -> some View {
        ZStack {
            Circle()
                .stroke(Color.white.opacity(0.12), lineWidth: 30)

            Circle()
                .trim(from: 0, to: isActive ? 1 : 0.02)
                .stroke(
                    LinearGradient(
                        colors: [Color.indigo.opacity(0.95), Color.accentColor.opacity(0.85)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    style: StrokeStyle(lineWidth: 30, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .shadow(color: Color.indigo.opacity(isActive ? 0.32 : 0), radius: 22)

            Image(systemName: isActive ? "moon.zzz.fill" : "power")
                .font(.system(size: 54, weight: .medium))
                .foregroundStyle(isActive ? Color.indigo : NBColor.secondaryText)
                .contentTransition(.symbolEffect(.replace))
        }
        .frame(width: 236, height: 236)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(isActive ? "A sleep routine is enabled" : "No sleep routine is enabled")
    }

    private func scheduleSummary(_ routine: Routine?) -> some View {
        HStack(spacing: 0) {
            scheduleTime(
                title: "Bedtime",
                symbol: "moon.zzz.fill",
                minutes: routine?.schedule.startMinutes
            )

            Rectangle()
                .fill(NBColor.separator)
                .frame(width: 1, height: 56)

            scheduleTime(
                title: "Wake",
                symbol: "bell.fill",
                minutes: routine?.schedule.endMinutes
            )
        }
        .frame(maxWidth: .infinity)
    }

    private func scheduleTime(title: String, symbol: String, minutes: Int?) -> some View {
        VStack(spacing: NBSpacing.small) {
            Label(title, systemImage: symbol)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(NBColor.secondaryText)
            Text(minutes.map(formattedTime) ?? "— —")
                .font(.title3.monospacedDigit().weight(.medium))
        }
        .frame(maxWidth: .infinity)
    }

    private func formattedTime(_ minutes: Int) -> String {
        let normalized = minutes == 1_440 ? 0 : minutes
        var components = DateComponents()
        components.hour = normalized / 60
        components.minute = normalized % 60
        guard let date = Calendar.current.date(from: components) else { return "— —" }
        return date.formatted(date: .omitted, time: .shortened)
    }
}

private struct SleepInfoSheet: View {
    var body: some View {
        VStack(alignment: .leading, spacing: NBSpacing.large) {
            Image(systemName: "moon.zzz.fill")
                .font(.system(size: 34, weight: .semibold))
                .foregroundStyle(Color.indigo)

            Text("Sleep Mode")
                .font(.title.bold())

            Text("Routines apply your on-device NBlocker preferences on the schedule you choose. System-wide app blocking still requires provisioned Screen Time capabilities.")
                .font(.body)
                .foregroundStyle(NBColor.secondaryText)
                .fixedSize(horizontal: false, vertical: true)

            Spacer()
        }
        .padding(NBSpacing.xLarge)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct NBSpringPressButtonStyle: ButtonStyle {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(reduceMotion || !configuration.isPressed ? 1 : 0.975)
            .brightness(configuration.isPressed ? -0.06 : 0)
            .animation(reduceMotion ? nil : NBAnimation.interactive, value: configuration.isPressed)
    }
}
