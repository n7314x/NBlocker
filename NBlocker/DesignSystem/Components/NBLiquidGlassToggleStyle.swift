import SwiftUI

struct NBLiquidGlassToggleStyle: ToggleStyle {
    var tint: Color = .accentColor
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: NBSpacing.medium) {
            configuration.label

            Spacer(minLength: NBSpacing.small)

            ZStack {
                Capsule()
                    .fill(configuration.isOn ? tint.opacity(0.16) : Color.white.opacity(0.035))

                Circle()
                    .fill(configuration.isOn ? Color.white : Color.white.opacity(0.70))
                    .frame(width: 25, height: 25)
                    .shadow(color: configuration.isOn ? tint.opacity(0.65) : .black.opacity(0.35), radius: 7, y: 2)
                    .offset(x: configuration.isOn ? 10 : -10)
            }
            .frame(width: 52, height: 34)
            .glassEffect(
                .regular.tint(configuration.isOn ? tint.opacity(0.42) : Color.white.opacity(0.04)).interactive(),
                in: Capsule()
            )
            .overlay {
                Capsule()
                    .stroke(Color.white.opacity(configuration.isOn ? 0.24 : 0.10), lineWidth: 0.7)
                    .allowsHitTesting(false)
            }
            .allowsHitTesting(false)
        }
        .frame(minHeight: 48)
        .contentShape(Rectangle())
        .onTapGesture {
            guard isEnabled else { return }
            withAnimation(reduceMotion ? NBAnimation.quick : .spring(response: 0.30, dampingFraction: 0.78)) {
                configuration.isOn.toggle()
            }
            HapticManager.play(.selection)
        }
        .opacity(isEnabled ? 1 : 0.45)
        .animation(reduceMotion ? nil : NBAnimation.interactive, value: configuration.isOn)
        .accessibilityElement(children: .combine)
        .accessibilityValue(configuration.isOn ? "On" : "Off")
        .accessibilityAddTraits(.isButton)
        .accessibilityAction {
            guard isEnabled else { return }
            configuration.isOn.toggle()
            HapticManager.play(.selection)
        }
    }
}
