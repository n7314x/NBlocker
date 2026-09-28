import SwiftUI

struct PlatformUsageCard: View {
    let platform: Platform
    let statistics: UsageStatistics

    var body: some View {
        NBCard {
            HStack(spacing: NBSpacing.standard) {
                NBPlatformIcon(platform: platform, size: 48)
                VStack(alignment: .leading, spacing: 3) {
                    Text(platform.displayName).font(.headline)
                    Text("\(statistics.sessions) sessions")
                        .font(.caption)
                        .foregroundStyle(NBColor.secondaryText)
                }
                Spacer()
                Text(statistics.duration.compactDuration)
                    .font(.system(.title3, design: .rounded, weight: .semibold))
                    .contentTransition(.numericText())
            }
        }
    }
}
