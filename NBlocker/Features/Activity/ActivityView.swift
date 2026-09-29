import SwiftUI

struct ActivityView: View {
    @Environment(AppEnvironment.self) private var environment

    var body: some View {
        let total = environment.usage.statistics()
        let days = environment.usage.lastSevenDays()

        NBRootScrollView {
            NBSectionHeader(
                title: "Activity",
                subtitle: "Only time spent inside NBlocker is counted"
            )

            NBUsageRing(
                progress: min(total.duration / 3_600, 1),
                value: total.duration.compactDuration,
                label: "today"
            )
            .frame(maxWidth: .infinity)

            NBCard {
                NBSectionHeader(title: "Last seven days", subtitle: "Local app-contained sessions")
                NBUsageChart(days: days)
            }

            ForEach(Platform.allCases) { platform in
                NavigationLink {
                    ActivityDetailView(platform: platform)
                } label: {
                    PlatformUsageCard(
                        platform: platform,
                        statistics: environment.usage.statistics(for: platform)
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .accessibilityIdentifier("screen.activity")
    }
}
