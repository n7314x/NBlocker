import SwiftUI

struct BrowserMenuView: View {
    let model: WebViewModel
    let showAccounts: () -> Void
    let openClipboard: () -> Void
    let showSettings: () -> Void
    let exitToHome: () -> Void

    var body: some View {
        GlassEffectContainer(spacing: NBSpacing.small) {
            HStack(spacing: 2) {
                control("chevron.backward", "Back", enabled: model.state.canGoBack) {
                    model.goBack()
                }
                control("house.fill", "Home", action: exitToHome)
                control("arrow.clockwise", "Refresh") {
                    model.reload()
                }
                control("chevron.forward", "Forward", enabled: model.state.canGoForward) {
                    model.goForward()
                }
                control("person.2.fill", "Switch accounts", action: showAccounts)
                control("clipboard.fill", "Open link from clipboard", action: openClipboard)

                Capsule()
                    .fill(Color.white.opacity(0.18))
                    .frame(width: 1, height: 24)
                    .padding(.horizontal, 5)
                    .allowsHitTesting(false)
                    .accessibilityHidden(true)

                control("slider.horizontal.3", "Settings", action: showSettings)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .glassEffect(.regular, in: Capsule())
        }
        .overlay {
            Capsule()
                .stroke(Color.white.opacity(0.13), lineWidth: 0.6)
                .allowsHitTesting(false)
        }
        .shadow(color: .black.opacity(0.58), radius: 24, y: 12)
        .shadow(color: Color.accentColor.opacity(0.12), radius: 16)
        .accessibilityIdentifier("browser.controlsMenu")
    }

    private func control(
        _ symbol: String,
        _ title: String,
        enabled: Bool = true,
        action: @escaping () -> Void
    ) -> some View {
        Button {
            HapticManager.play(.light)
            action()
        } label: {
            Image(systemName: symbol)
                .font(.system(size: 16, weight: .semibold))
                .frame(width: 38, height: 44)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(!enabled)
        .opacity(enabled ? 1 : 0.28)
        .accessibilityLabel(title)
        .accessibilityIdentifier("browser.action.\(title.lowercased().replacingOccurrences(of: " ", with: "-"))")
    }
}
