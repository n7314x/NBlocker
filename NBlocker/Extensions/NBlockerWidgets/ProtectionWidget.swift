import SwiftUI
import WidgetKit

private struct ProtectionEntry: TimelineEntry {
    let date: Date
}

private struct ProtectionProvider: TimelineProvider {
    func placeholder(in context: Context) -> ProtectionEntry { ProtectionEntry(date: .now) }
    func getSnapshot(in context: Context, completion: @escaping (ProtectionEntry) -> Void) {
        completion(ProtectionEntry(date: .now))
    }
    func getTimeline(in context: Context, completion: @escaping (Timeline<ProtectionEntry>) -> Void) {
        completion(Timeline(entries: [ProtectionEntry(date: .now)], policy: .after(.now.addingTimeInterval(900))))
    }
}

struct ProtectionWidget: Widget {
    let kind = "NBlockerProtection"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ProtectionProvider()) { _ in
            VStack(alignment: .leading, spacing: 8) {
                Image(systemName: "shield.lefthalf.filled").font(.title).foregroundStyle(.cyan)
                Text("Web filtering").font(.headline)
                Text("Open NBlocker for live status").font(.caption2).foregroundStyle(.secondary)
            }
            .containerBackground(.black, for: .widget)
        }
        .configurationDisplayName("Protection")
        .description("A shortcut to NBlocker protection status.")
        .supportedFamilies([.systemSmall])
    }
}
