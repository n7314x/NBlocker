import SwiftUI

struct BrowserMenuView: View {
    let model: WebViewModel
    let showAccounts: () -> Void
    let showLinkActions: () -> Void
    let showSettings: () -> Void
    let closeBrowser: () -> Void
    let dismiss: () -> Void

    private let columns = Array(repeating: GridItem(.flexible(), spacing: NBSpacing.small), count: 4)

    var body: some View {
        LazyVGrid(columns: columns, spacing: NBSpacing.small) {
            control("chevron.backward", "Back", enabled: model.state.canGoBack) {
                model.goBack()
                dismiss()
            }
            control("house.fill", "Home") {
                model.loadHome()
                dismiss()
            }
            control("arrow.clockwise", "Refresh") {
                model.reload()
                dismiss()
            }
            control("chevron.forward", "Forward", enabled: model.state.canGoForward) {
                model.goForward()
                dismiss()
            }
            control("person.2.fill", "Accounts", action: showAccounts)
            control("link", "Link", enabled: model.state.currentURL != nil, action: showLinkActions)
            control("gearshape.fill", "Settings", action: showSettings)
            control("xmark", "Close", role: .destructive, action: closeBrowser)
        }
        .padding(NBSpacing.medium)
        .frame(maxWidth: 340)
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: NBRadius.prominent, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: NBRadius.prominent, style: .continuous)
                .stroke(Color.white.opacity(0.12), lineWidth: 0.5)
                .allowsHitTesting(false)
        }
        .shadow(color: .black.opacity(0.55), radius: 24, y: 12)
        .accessibilityIdentifier("browser.controlsMenu")
    }

    private func control(
        _ symbol: String,
        _ title: String,
        enabled: Bool = true,
        role: ButtonRole? = nil,
        action: @escaping () -> Void
    ) -> some View {
        Button(role: role) {
            HapticManager.play(.light)
            action()
        } label: {
            VStack(spacing: NBSpacing.small) {
                Image(systemName: symbol)
                    .font(.system(size: 17, weight: .semibold))
                    .frame(height: 22)
                Text(title)
                    .font(.caption2.weight(.medium))
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, minHeight: 58)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(!enabled)
        .opacity(enabled ? 1 : 0.32)
        .accessibilityLabel(title)
        .accessibilityIdentifier("browser.action.\(title.lowercased())")
    }
}
