import SwiftUI

struct NBUsageChart: View {
    let days: [DailyUsage]

    var body: some View {
        let maximum = max(days.map(\.duration).max() ?? 0, 60)
        HStack(alignment: .bottom, spacing: NBSpacing.small) {
            ForEach(days) { day in
                VStack(spacing: NBSpacing.small) {
                    RoundedRectangle(cornerRadius: 5, style: .continuous)
                        .fill(Color.accentColor.opacity(0.78))
                        .frame(height: CGFloat(max(4, 66 * day.duration / maximum)))
                    Text(day.date.shortWeekday)
                        .font(.caption2)
                        .foregroundStyle(NBColor.secondaryText)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .frame(height: 92, alignment: .bottom)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Seven day usage chart")
    }
}
