import SwiftUI

struct NBPlatformCarousel: View {
    @Binding var selection: Platform
    let open: (Platform) -> Void
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var visiblePlatform: Platform?

    var body: some View {
        VStack(spacing: NBSpacing.small) {
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0) {
                    ForEach(Platform.allCases) { platform in
                        Button {
                            open(platform)
                        } label: {
                            VStack(spacing: NBSpacing.small) {
                                NBPlatformIcon(platform: platform, size: 58)

                                Text(platform.displayName)
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(.white)

                                Text("Open intentionally")
                                    .font(.caption2)
                                    .foregroundStyle(NBColor.secondaryText)
                            }
                            .scaleEffect(
                                selection == platform || reduceMotion ? 1 : 0.96
                            )
                            .animation(NBAnimation.interactive, value: selection)
                            .frame(maxWidth: .infinity)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        .containerRelativeFrame(.horizontal)
                        .id(platform)
                        .accessibilityIdentifier("platform.\(platform.rawValue)")
                    }
                }
                .scrollTargetLayout()
            }
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.paging)
            .scrollPosition(id: $visiblePlatform)
            .accessibilityIdentifier("home.platformCarousel")

            HStack(spacing: NBSpacing.small) {
                ForEach(Platform.allCases) { platform in
                    Circle()
                        .fill(selection == platform ? Color.white : NBColor.quietText)
                        .frame(width: 5, height: 5)
                }
            }
            .accessibilityHidden(true)
            .allowsHitTesting(false)
        }
        .onAppear {
            visiblePlatform = selection
        }
        .onChange(of: selection) { _, newValue in
            guard visiblePlatform != newValue else { return }
            visiblePlatform = newValue
        }
        .onChange(of: visiblePlatform) { _, newValue in
            guard let newValue, selection != newValue else { return }
            selection = newValue
            HapticManager.play(.selection)
        }
    }
}
