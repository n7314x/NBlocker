import SwiftUI

struct InstagramSettingsHeader: View {
    let filteringEnabled: Bool
    let done: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var isPresented = false

    var body: some View {
        VStack(spacing: NBSpacing.medium) {
            Capsule()
                .fill(Color.white.opacity(0.28))
                .frame(width: 38, height: 5)
                .accessibilityHidden(true)

            ZStack {
                HStack {
                    NBPlatformIcon(platform: .instagram, size: 34)

                    Spacer()

                    Button("Done", action: done)
                        .font(.subheadline.weight(.semibold))
                        .padding(.horizontal, NBSpacing.small)
                        .frame(minHeight: 42)
                        .buttonStyle(.glass)
                        .tint(Platform.instagram.accentColor)
                }

                Text("Instagram")
                    .font(.title2.weight(.semibold))
            }

            HStack(spacing: NBSpacing.small) {
                statusChip(
                    filteringEnabled ? "Filters active" : "Filters paused",
                    symbol: filteringEnabled ? "checkmark.shield.fill" : "pause.circle.fill",
                    tint: filteringEnabled ? NBColor.success : NBColor.warning
                )
                statusChip("On-device", symbol: "iphone", tint: Platform.instagram.secondaryAccentColor)
                Spacer(minLength: 0)
            }
        }
        .opacity(isPresented ? 1 : 0)
        .offset(y: reduceMotion || isPresented ? 0 : -8)
        .onAppear {
            withAnimation(reduceMotion ? NBAnimation.quick : NBAnimation.content) {
                isPresented = true
            }
        }
    }

    private func statusChip(_ title: String, symbol: String, tint: Color) -> some View {
        Label(title, systemImage: symbol)
            .font(.caption.weight(.semibold))
            .foregroundStyle(Color.white.opacity(0.82))
            .padding(.horizontal, NBSpacing.medium)
            .frame(minHeight: 30)
            .background(tint.opacity(0.10), in: Capsule())
            .overlay {
                Capsule()
                    .stroke(tint.opacity(0.28), lineWidth: 0.8)
                    .allowsHitTesting(false)
            }
    }
}
