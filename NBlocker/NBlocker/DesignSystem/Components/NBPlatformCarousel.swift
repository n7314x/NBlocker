import SwiftUI

struct NBPlatformCarousel: View {
    @Binding var selection: Platform
    let open: (Platform) -> Void
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        TabView(selection: $selection) {
            ForEach(Platform.allCases) { platform in
                Button {
                    open(platform)
                } label: {
                    VStack(spacing: NBSpacing.standard) {
                        NBPlatformIcon(platform: platform, size: 96)
                        Text(platform.displayName)
                            .font(.title3.weight(.semibold))
                            .foregroundStyle(.white)
                        Text("Open intentionally")
                            .font(.caption)
                            .foregroundStyle(NBColor.secondaryText)
                    }
                    .scaleEffect(selection == platform && !reduceMotion ? 1 : 0.92)
                    .animation(NBAnimation.interactive, value: selection)
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.plain)
                .tag(platform)
                .accessibilityIdentifier("platform.\(platform.rawValue)")
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .frame(height: 230)
        .onChange(of: selection) { _, _ in HapticManager.play(.selection) }
    }
}
