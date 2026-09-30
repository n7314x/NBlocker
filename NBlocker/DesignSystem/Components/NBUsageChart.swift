import SwiftUI

struct NBUsageChart: View {
    let days: [DailyUsage]

    var body: some View {
        let maximum = max(days.map(\.duration).max() ?? 0, 60)
        HStack(alignment: .bottom, spacing: NBSpacing.medium) {
            ForEach(days) { day in
                VStack(spacing: NBSpacing.small) {
                    if day.duration > 0 {
                        Text(day.duration.compactDuration)
                            .font(.caption2.monospacedDigit())
                            .foregroundStyle(NBColor.secondaryText)
                    } else {
                        Spacer().frame(height: 14)
                    }

                    RoundedRectangle(cornerRadius: 5, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [.white, Color.accentColor.opacity(0.55)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(height: CGFloat(max(4, 124 * day.duration / maximum)))
                    Text(day.date.shortWeekday)
                        .font(.caption2)
                        .foregroundStyle(NBColor.secondaryText)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .frame(height: 164, alignment: .bottom)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Seven day usage chart")
    }
}
