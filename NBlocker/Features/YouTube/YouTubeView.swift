import SwiftUI

struct YouTubeView: View {
    @State private var model: WebViewModel

    init(settings: PlatformSettings, usageTracker: UsageTracker) {
        _model = State(initialValue: WebViewModel(
            platform: .youtube,
            settings: settings,
            usageTracker: usageTracker
        ))
    }

    var body: some View {
        PlatformBrowserView(model: model)
    }
}
