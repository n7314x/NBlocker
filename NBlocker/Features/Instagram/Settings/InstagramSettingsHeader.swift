import SwiftUI

struct InstagramSettingsHeader: View {
    let filteringEnabled: Bool
    let done: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var isPresented = false

    var body: some View {
        VStack(spacing: NBSpacing.medium) {
            Capsule()
                .fill(Color.white.opacity(0.30))
                .frame(width: 36, height: 5)
                .accessibilityHidden(true)

            HStack(spacing: NBSpacing.medium) {
                NBPlatformIcon(platform: .instagram, size: 50)

                VStack(alignment: .leading, spacing: 2) {
                    Text("CONTROL PANEL")
                        .font(.caption2.weight(.bold))
                        .tracking(1.2)
                        .foregroundStyle(Platform.instagram.accentColor)
                    Text("Instagram")
                        .font(.title3.weight(.bold))
                    Text("Tune the experience, keep the connection")
                        .font(.caption)
                        .foregroundStyle(NBColor.secondaryText)
                        .lineLimit(1)
                }

                Spacer(minLength: NBSpacing.small)

                Button(action: done) {
                    Image(systemName: "checkmark")
                        .font(.system(size: 15, weight: .bold))
                        .frame(width: 42, height: 42)
                }
                .buttonStyle(.glassProminent)
                .buttonBorderShape(.circle)
                .tint(Platform.instagram.accentColor)
                .accessibilityLabel("Done")
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
        .padding(NBSpacing.standard)
        .background {
            ZStack {
                RoundedRectangle(cornerRadius: NBRadius.prominent, style: .continuous)
                    .fill(NBColor.cardRaised)
                RadialGradient(
                    colors: [Platform.instagram.accentColor.opacity(0.15), .clear],
                    center: .topLeading,
                    startRadius: 0,
                    endRadius: 230
                )
                .clipShape(RoundedRectangle(cornerRadius: NBRadius.prominent, style: .continuous))
                .allowsHitTesting(false)
            }
        }
        .overlay {
            RoundedRectangle(cornerRadius: NBRadius.prominent, style: .continuous)
                .stroke(Color.white.opacity(0.12), lineWidth: 0.7)
                .allowsHitTesting(false)
        }
        .shadow(color: Platform.instagram.accentColor.opacity(0.09), radius: 22, y: 8)
        .opacity(isPresented ? 1 : 0)
        .offset(y: reduceMotion || isPresented ? 0 : -10)
        .onAppear {
            withAnimation(reduceMotion ? NBAnimation.quick : .spring(response: 0.46, dampingFraction: 0.88)) {
                isPresented = true
            }
        }
    }

    private func statusChip(_ title: String, symbol: String, tint: Color) -> some View {
        Label(title, systemImage: symbol)
            .font(.caption2.weight(.semibold))
            .foregroundStyle(Color.white.opacity(0.80))
            .padding(.horizontal, NBSpacing.medium)
            .frame(minHeight: 28)
            .background(tint.opacity(0.10), in: Capsule())
            .overlay {
                Capsule()
                    .stroke(tint.opacity(0.24), lineWidth: 0.6)
                    .allowsHitTesting(false)
            }
    }
}
