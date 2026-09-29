import SwiftUI

struct PlatformUsageCard: View {
    let platform: Platform
    let statistics: UsageStatistics

    var body: some View {
        NBCard {
            HStack(spacing: NBSpacing.medium) {
                NBPlatformIcon(platform: platform, size: 42)
                VStack(alignment: .leading, spacing: 3) {
                    Text(platform.displayName).font(.subheadline.weight(.semibold))
                    Text("\(statistics.sessions) sessions")
                        .font(.caption)
                        .foregroundStyle(NBColor.secondaryText)
                }
                Spacer()
                Text(statistics.duration.compactDuration)
                    .font(.system(.body, design: .rounded, weight: .semibold))
                    .contentTransition(.numericText())
            }
        }
    }
}
