import SwiftUI

struct PlatformUsageView: View {
    let platform: Platform
    let statistics: UsageStatistics

    var body: some View {
        VStack(spacing: NBSpacing.xSmall) {
            Text("\(platform.displayName) today")
                .font(NBTypography.label)
                .foregroundStyle(NBColor.secondaryText)
            Text(statistics.duration.compactDuration)
                .font(NBTypography.usageValue)
                .contentTransition(.numericText())
            Text("\(statistics.sessions) sessions · \(statistics.preventedNavigations) detours prevented")
                .font(.caption)
                .foregroundStyle(NBColor.quietText)
        }
        .animation(NBAnimation.content, value: platform)
    }
}
