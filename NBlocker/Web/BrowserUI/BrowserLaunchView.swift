import SwiftUI

struct BrowserLaunchView: View {
    let platform: Platform
    let presentation: BrowserPresentationState
    let retry: () -> Void
    let close: () -> Void
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            RadialGradient(
                colors: [
                    platform.accentColor.opacity(0.22),
                    platform.secondaryAccentColor.opacity(0.08),
                    .clear
                ],
                center: .center,
                startRadius: 10,
                endRadius: 280
            )
            .ignoresSafeArea()
            .allowsHitTesting(false)

            VStack(spacing: NBSpacing.large) {
                NBPlatformIcon(platform: platform, size: 82)
                    .padding(.bottom, NBSpacing.small)

                switch presentation {
                case .preparing:
                    VStack(spacing: NBSpacing.small) {
                        Text("Applying your preferences")
                            .font(.title2.bold())
                            .accessibilityIdentifier("browser.loading")
                        Text("Setting up content filters for \(platform.displayName)")
                            .font(.subheadline)
                            .foregroundStyle(NBColor.secondaryText)
                            .multilineTextAlignment(.center)
                    }
                    LoadingDots(reduceMotion: reduceMotion)
                        .padding(.top, NBSpacing.small)

                case let .failed(message):
                    VStack(spacing: NBSpacing.small) {
                        Text("Couldn’t open \(platform.displayName)")
                            .font(.title2.bold())
                        Text(message)
                            .font(.subheadline)
                            .foregroundStyle(NBColor.secondaryText)
                            .multilineTextAlignment(.center)
                    }
                    Button("Try Again", action: retry)
                        .buttonStyle(.glassProminent)
                        .tint(platform.accentColor)
                        .padding(.top, NBSpacing.small)

                case .ready:
                    EmptyView()
                }
            }
            .padding(NBSpacing.xLarge)
            .frame(maxWidth: 420)

            VStack {
                HStack {
                    Spacer()
                    BrowserCloseButton(close: close)
                }
                Spacer()
            }
            .padding(NBSpacing.standard)
        }
        .accessibilityIdentifier("browser.launch")
    }
}

private struct LoadingDots: View {
    let reduceMotion: Bool

    var body: some View {
        TimelineView(.periodic(from: .now, by: reduceMotion ? 2 : 0.24)) { context in
            let active = reduceMotion ? 0 : Int(context.date.timeIntervalSinceReferenceDate / 0.24) % 3
            HStack(spacing: NBSpacing.small) {
                ForEach(0..<3, id: \.self) { index in
                    Circle()
                        .fill(Color.white.opacity(reduceMotion || index == active ? 0.82 : 0.24))
                        .frame(width: 6, height: 6)
                }
            }
        }
        .frame(height: 12)
        .accessibilityLabel("Loading")
    }
}
