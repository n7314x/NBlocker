import SwiftUI

struct PlatformUsageView: View {
    let platform: Platform
    let statistics: UsageStatistics

    var body: some View {
        VStack(spacing: 2) {
            Text("\(platform.displayName) today")
                .font(.subheadline.weight(.medium))
                .foregroundStyle(NBColor.secondaryText)
            Text(statistics.duration.compactDuration)
                .font(NBTypography.usageValue)
                .contentTransition(.numericText())
            Text("\(statistics.sessions) sessions · \(statistics.preventedNavigations) detours prevented")
                .font(.footnote)
                .foregroundStyle(NBColor.quietText)
        }
        .animation(NBAnimation.content, value: platform)
    }
}
