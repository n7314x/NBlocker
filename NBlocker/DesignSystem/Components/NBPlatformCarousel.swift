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
                    VStack(spacing: NBSpacing.small) {
                        NBPlatformIcon(platform: platform, size: 66)

                        Text(platform.displayName)
                            .font(.headline)
                            .foregroundStyle(.white)

                        Text("Open intentionally")
                            .font(.caption2)
                            .foregroundStyle(NBColor.secondaryText)
                    }
                    .scaleEffect(selection == platform && !reduceMotion ? 1 : 0.95)
                    .animation(NBAnimation.interactive, value: selection)
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.plain)
                .tag(platform)
                .accessibilityIdentifier("platform.\(platform.rawValue)")
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .frame(height: 155)
        .onChange(of: selection) { _, _ in
            HapticManager.play(.selection)
        }
    }
}
