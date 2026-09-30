import SwiftUI

struct ActivityView: View {
    @Environment(AppEnvironment.self) private var environment
    @State private var showsInfo = false

    var body: some View {
        let total = environment.usage.statistics()
        let days = environment.usage.lastSevenDays()
        let peakDuration = days.map(\.duration).max() ?? 0
        let relativeProgress = peakDuration > 0 ? total.duration / peakDuration : 0

        NBRootScrollView(spacing: NBSpacing.xLarge) {
            NBScreenHeader("Activity")

            HStack(spacing: NBSpacing.large) {
                NBUsageRing(
                    progress: min(relativeProgress, 1),
                    value: total.duration.compactDuration,
                    label: "today"
                )

                VStack(alignment: .leading, spacing: 5) {
                    Text("Today in NBlocker")
                        .font(.title3.weight(.semibold))
                    Text("\(total.sessions) local browser sessions")
                        .font(.subheadline)
                        .foregroundStyle(NBColor.secondaryText)
                    Text("Compared with your busiest day this week")
                        .font(.caption)
                        .foregroundStyle(NBColor.quietText)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer(minLength: 0)

                Button {
                    showsInfo = true
                } label: {
                    Image(systemName: "info.circle")
                        .font(.title3.weight(.semibold))
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.plain)
                .foregroundStyle(NBColor.quietText)
                .accessibilityLabel("About activity data")
            }

            VStack(alignment: .leading, spacing: NBSpacing.standard) {
                Label("Last 7 Days", systemImage: "chart.bar.fill")
                    .font(.title3.weight(.semibold))

                NBUsageChart(days: days)
            }

            NBCard {
                VStack(alignment: .leading, spacing: NBSpacing.standard) {
                    Label("Today in NBlocker", systemImage: "hourglass")
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(NBColor.secondaryText)

                    HStack(alignment: .firstTextBaseline, spacing: NBSpacing.small) {
                        Text(total.duration.compactDuration)
                            .font(.system(size: 34, weight: .medium, design: .rounded).monospacedDigit())
                            .contentTransition(.numericText())
                        Text("total")
                            .font(.subheadline)
                            .foregroundStyle(NBColor.secondaryText)
                    }

                    ForEach(Platform.allCases) { platform in
                        if platform != Platform.allCases.first {
                            Divider().overlay(NBColor.separator)
                        }
                        NavigationLink {
                            ActivityDetailView(platform: platform)
                        } label: {
                            activityRow(
                                platform,
                                statistics: environment.usage.statistics(for: platform),
                                totalDuration: total.duration
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .sheet(isPresented: $showsInfo) {
            ActivityInfoSheet()
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
                .presentationCornerRadius(NBRadius.sheet)
                .presentationBackground(NBColor.sheet)
        }
        .accessibilityIdentifier("screen.activity")
    }

    private func activityRow(
        _ platform: Platform,
        statistics: UsageStatistics,
        totalDuration: TimeInterval
    ) -> some View {
        VStack(spacing: NBSpacing.small) {
            HStack(spacing: NBSpacing.medium) {
                NBPlatformIcon(platform: platform, size: 38)
                Text(platform.displayName)
                    .font(.body.weight(.medium))
                Spacer()
                Text(statistics.duration.compactDuration)
                    .font(.body.monospacedDigit().weight(.medium))
                NBDisclosureIndicator()
            }

            GeometryReader { proxy in
                let fraction = totalDuration > 0 ? statistics.duration / totalDuration : 0
                Capsule()
                    .fill(Color.white.opacity(0.08))
                    .overlay(alignment: .leading) {
                        Capsule()
                            .fill(platform.accentColor)
                            .frame(width: proxy.size.width * min(max(fraction, 0), 1))
                    }
            }
            .frame(height: 6)
        }
        .frame(minHeight: 54)
    }
}

private struct ActivityInfoSheet: View {
    var body: some View {
        VStack(alignment: .leading, spacing: NBSpacing.large) {
            Text("How Activity works")
                .font(.title.bold())

            Text("NBlocker counts only sessions inside its own Instagram and YouTube browsers. It does not read device-wide Screen Time or browsing history.")
                .font(.body)
                .foregroundStyle(NBColor.secondaryText)

            NBCard {
                VStack(spacing: 0) {
                    explanationRow("Duration", "Time visible inside NBlocker")
                    Divider().overlay(NBColor.separator)
                    explanationRow("Sessions", "Each browser visit")
                    Divider().overlay(NBColor.separator)
                    explanationRow("Prevented", "Routes NBlocker actually cancelled")
                }
            }

            Spacer()
        }
        .padding(NBSpacing.xLarge)
    }

    private func explanationRow(_ title: String, _ detail: String) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(title).font(.headline)
            Text(detail).font(.subheadline).foregroundStyle(NBColor.secondaryText)
        }
        .frame(maxWidth: .infinity, minHeight: 62, alignment: .leading)
    }
}
