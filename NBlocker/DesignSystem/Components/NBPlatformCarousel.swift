import SwiftUI

struct NBPlatformCarousel: View {
    @Binding var selection: Platform
    let open: (Platform) -> Void
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var visiblePlatform: Platform?

    var body: some View {
        VStack(spacing: NBSpacing.medium) {
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0) {
                    ForEach(Platform.allCases) { platform in
                        Button {
                            open(platform)
                        } label: {
                            PlatformLaunchLabel(platform: platform)
                                .scaleEffect(selection == platform || reduceMotion ? 1 : 0.94)
                                .opacity(selection == platform ? 1 : 0.72)
                                .animation(NBAnimation.interactive, value: selection)
                                .frame(maxWidth: .infinity)
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(PremiumPlatformLaunchButtonStyle(
                            accent: platform.accentColor,
                            reduceMotion: reduceMotion
                        ))
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
            .frame(height: 270)
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

private struct PlatformLaunchLabel: View {
    let platform: Platform

    var body: some View {
        VStack(spacing: NBSpacing.large) {
            ZStack {
                Circle()
                    .fill(platform.accentColor.opacity(0.18))
                    .frame(width: 176, height: 176)
                    .blur(radius: 26)
                    .allowsHitTesting(false)

                NBPlatformIcon(platform: platform, size: 142)
            }

            Label("Open \(platform.displayName)", systemImage: "arrow.up.right")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.white)
                .padding(.horizontal, NBSpacing.standard)
                .frame(minHeight: 38)
                .background(Color.white.opacity(0.07), in: Capsule())
                .overlay {
                    Capsule()
                        .stroke(Color.white.opacity(0.12), lineWidth: 0.8)
                        .allowsHitTesting(false)
                }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .shadow(color: platform.accentColor.opacity(0.22), radius: 24)
    }
}

private struct PremiumPlatformLaunchButtonStyle: ButtonStyle {
    let accent: Color
    let reduceMotion: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(reduceMotion || !configuration.isPressed ? 1 : 0.965)
            .rotation3DEffect(
                .degrees(reduceMotion || !configuration.isPressed ? 0 : 1.2),
                axis: (x: 1, y: -0.35, z: 0),
                perspective: 0.7
            )
            .brightness(configuration.isPressed ? 0.08 : 0)
            .shadow(color: accent.opacity(configuration.isPressed ? 0.28 : 0), radius: 26)
            .animation(reduceMotion ? nil : .spring(response: 0.28, dampingFraction: 0.72), value: configuration.isPressed)
    }
}
