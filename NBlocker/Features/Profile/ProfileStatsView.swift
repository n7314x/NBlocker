import SwiftUI

struct ProfileStatsView: View {
    let usage: UsageStatistics

    var body: some View {
        HStack(spacing: 0) {
            stat(usage.duration.compactDuration, "Today", symbol: "clock.arrow.circlepath")
            divider
            stat("\(usage.sessions)", "Sessions", symbol: "person.2")
            divider
            stat("\(usage.preventedNavigations)", "Prevented", symbol: "eye.slash")
        }
        .frame(maxWidth: .infinity)
    }

    private func stat(_ value: String, _ label: String, symbol: String) -> some View {
        VStack(spacing: 5) {
            Image(systemName: symbol)
                .font(.body.weight(.semibold))
            Text(value).font(.title3.monospacedDigit().weight(.medium))
            Text(label).font(.caption).foregroundStyle(NBColor.secondaryText)
        }
        .frame(maxWidth: .infinity)
    }

    private var divider: some View {
        Rectangle()
            .fill(NBColor.separator)
            .frame(width: 1, height: 66)
    }
}
