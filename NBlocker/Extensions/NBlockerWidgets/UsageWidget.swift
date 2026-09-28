import SwiftUI
import WidgetKit

private struct UsageEntry: TimelineEntry {
    let date: Date
    let minutes: Int
}

private struct UsageProvider: TimelineProvider {
    func placeholder(in context: Context) -> UsageEntry { UsageEntry(date: .now, minutes: 12) }
    func getSnapshot(in context: Context, completion: @escaping (UsageEntry) -> Void) {
        completion(UsageEntry(date: .now, minutes: 12))
    }
    func getTimeline(in context: Context, completion: @escaping (Timeline<UsageEntry>) -> Void) {
        completion(Timeline(entries: [UsageEntry(date: .now, minutes: 0)], policy: .after(.now.addingTimeInterval(900))))
    }
}

struct UsageWidget: Widget {
    let kind = "NBlockerUsage"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: UsageProvider()) { entry in
            VStack(alignment: .leading, spacing: 6) {
                Label("NBlocker", systemImage: "chart.bar.fill").font(.caption.bold())
                Text("\(entry.minutes)m").font(.title.bold().monospacedDigit())
                Text("today in NBlocker").font(.caption2).foregroundStyle(.secondary)
            }
            .containerBackground(.black, for: .widget)
        }
        .configurationDisplayName("Usage")
        .description("App-contained Instagram and YouTube usage.")
        .supportedFamilies([.systemSmall])
    }
}
