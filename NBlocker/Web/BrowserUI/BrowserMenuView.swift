import SwiftUI

struct BrowserMenuView: View {
    let model: WebViewModel
    let showAccounts: () -> Void
    let openClipboard: () -> Void
    let showSettings: () -> Void
    let exitToHome: () -> Void

    var body: some View {
        GlassEffectContainer(spacing: 0) {
            HStack(spacing: 0) {
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
                control("link", "Open link from clipboard", action: openClipboard)

                Rectangle()
                    .fill(Color.white.opacity(0.18))
                    .frame(width: 1, height: 30)
                    .padding(.horizontal, 6)
                    .allowsHitTesting(false)
                    .accessibilityHidden(true)

                control("gearshape.fill", "Settings", action: showSettings)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .glassEffect(.regular.tint(Color.white.opacity(0.03)), in: Capsule())
        }
        .overlay {
            Capsule()
                .stroke(Color.white.opacity(0.24), lineWidth: 0.9)
                .allowsHitTesting(false)
        }
        .shadow(color: .black.opacity(0.62), radius: 24, y: 12)
        .shadow(color: Color.accentColor.opacity(0.10), radius: 18)
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
                .font(.system(size: 19, weight: .semibold))
                .frame(width: 42, height: 48)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(!enabled)
        .opacity(enabled ? 1 : 0.28)
        .accessibilityLabel(title)
        .accessibilityIdentifier("browser.action.\(title.lowercased().replacingOccurrences(of: " ", with: "-"))")
    }
}
