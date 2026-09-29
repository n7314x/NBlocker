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
                            PlatformLaunchLabel(platform: platform)
                            .scaleEffect(
                                selection == platform || reduceMotion ? 1 : 0.96
                            )
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
        HStack(spacing: NBSpacing.standard) {
            ZStack {
                Circle()
                    .fill(platform.accentColor.opacity(0.16))
                    .frame(width: 78, height: 78)
                    .blur(radius: 7)
                    .allowsHitTesting(false)

                NBPlatformIcon(platform: platform, size: 62)
            }

            VStack(alignment: .leading, spacing: NBSpacing.xSmall) {
                Text("OPEN INTENTIONALLY")
                    .font(.caption2.weight(.bold))
                    .tracking(0.9)
                    .foregroundStyle(platform.accentColor)

                Text(platform.displayName)
                    .font(.title3.weight(.bold))
                    .foregroundStyle(.white)

                Text(platform == .instagram ? "Your filters. Your pace." : "Watch with fewer distractions.")
                    .font(.caption)
                    .foregroundStyle(NBColor.secondaryText)
                    .lineLimit(1)
            }

            Spacer(minLength: NBSpacing.small)

            Image(systemName: "arrow.up.right")
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: 42, height: 42)
                .glassEffect(.regular.tint(platform.accentColor.opacity(0.32)).interactive(), in: Circle())
        }
        .padding(NBSpacing.standard)
        .background {
            ZStack {
                RoundedRectangle(cornerRadius: NBRadius.prominent, style: .continuous)
                    .fill(NBColor.cardRaised)
                LinearGradient(
                    colors: [platform.accentColor.opacity(0.13), .clear, platform.secondaryAccentColor.opacity(0.07)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .clipShape(RoundedRectangle(cornerRadius: NBRadius.prominent, style: .continuous))
                .allowsHitTesting(false)
            }
        }
        .overlay {
            RoundedRectangle(cornerRadius: NBRadius.prominent, style: .continuous)
                .stroke(
                    LinearGradient(
                        colors: [platform.accentColor.opacity(0.40), Color.white.opacity(0.08)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 0.8
                )
                .allowsHitTesting(false)
        }
        .shadow(color: platform.accentColor.opacity(0.17), radius: 22, y: 9)
        .padding(.horizontal, 2)
        .padding(.vertical, NBSpacing.small)
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
