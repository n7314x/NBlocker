import ActivityKit
import SwiftUI
import WidgetKit

struct WidgetFocusAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        var endsAt: Date
    }

    var routineName: String
}

struct FocusLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: WidgetFocusAttributes.self) { context in
            HStack {
                Image(systemName: "scope")
                Text(context.attributes.routineName)
                Spacer()
                Text(timerInterval: .now...context.state.endsAt, countsDown: true)
            }
            .padding()
            .activityBackgroundTint(.black)
            .activitySystemActionForegroundColor(.white)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) { Image(systemName: "scope") }
                DynamicIslandExpandedRegion(.center) { Text(context.attributes.routineName) }
                DynamicIslandExpandedRegion(.trailing) {
                    Text(timerInterval: .now...context.state.endsAt, countsDown: true)
                }
            } compactLeading: {
                Image(systemName: "scope")
            } compactTrailing: {
                Text(timerInterval: .now...context.state.endsAt, countsDown: true)
            } minimal: {
                Image(systemName: "scope")
            }
        }
    }
}
