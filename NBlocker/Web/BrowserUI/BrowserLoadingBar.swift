import SwiftUI

struct BrowserLoadingBar: View {
    let progress: Double

    var body: some View {
        GeometryReader { proxy in
            Capsule()
                .fill(Color.accentColor)
                .frame(width: proxy.size.width * min(max(progress, 0), 1), height: 3)
                .animation(NBAnimation.quick, value: progress)
        }
        .frame(height: 3)
        .accessibilityHidden(true)
    }
}
