import SwiftUI

struct ActivityDetailView: View {
    @Environment(AppEnvironment.self) private var environment
    let platform: Platform

    var body: some View {
        let statistics = environment.usage.statistics(for: platform)
        ScrollView {
            VStack(spacing: NBSpacing.standard) {
                PlatformUsageCard(platform: platform, statistics: statistics)
                NBCard {
                    metric("Longest session", statistics.longestSession.compactDuration)
                    Divider().overlay(NBColor.border)
                    metric("Navigation prevented", "\(statistics.preventedNavigations)")
                    Divider().overlay(NBColor.border)
                    metric("Reminders triggered", "\(statistics.remindersTriggered)")
                }
                Text("Counts reflect events NBlocker can directly observe inside its own browser.")
                    .font(.footnote)
                    .foregroundStyle(NBColor.secondaryText)
            }
            .padding(NBSpacing.standard)
        }
        .navigationTitle(platform.displayName)
    }

    private func metric(_ title: String, _ value: String) -> some View {
        HStack { Text(title); Spacer(); Text(value).foregroundStyle(NBColor.secondaryText) }
            .frame(minHeight: 42)
    }
}
