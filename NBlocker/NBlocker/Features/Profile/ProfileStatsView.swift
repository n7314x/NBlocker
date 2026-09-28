import SwiftUI

struct ProfileStatsView: View {
    let usage: UsageStatistics

    var body: some View {
        NBCard {
            HStack {
                stat(usage.duration.compactDuration, "Today")
                Spacer()
                stat("\(usage.sessions)", "Sessions")
                Spacer()
                stat("\(usage.preventedNavigations)", "Prevented")
            }
        }
    }

    private func stat(_ value: String, _ label: String) -> some View {
        VStack(spacing: 4) {
            Text(value).font(.headline.monospacedDigit())
            Text(label).font(.caption2).foregroundStyle(NBColor.secondaryText)
        }
    }
}
