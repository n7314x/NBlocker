import SwiftUI

struct BrowserToolbar: View {
    let model: WebViewModel
    let showSettings: () -> Void

    var body: some View {
        GlassEffectContainer(spacing: NBSpacing.small) {
            HStack(spacing: NBSpacing.xSmall) {
                item("chevron.backward", "Back", enabled: model.state.canGoBack, action: model.goBack)
                item("house.fill", "Platform home", action: model.loadHome)
                item("arrow.clockwise", "Reload", action: model.reload)
                item("chevron.forward", "Forward", enabled: model.state.canGoForward, action: model.goForward)
                Menu {
                    Button("Open in Safari", systemImage: "safari", action: model.openCurrentURLExternally)
                    Button("Platform Settings", systemImage: "slider.horizontal.3", action: showSettings)
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.body.weight(.semibold))
                        .frame(maxWidth: .infinity, minHeight: 50)
                }
                .accessibilityLabel("Browser menu")
            }
            .padding(6)
            .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 25, style: .continuous))
        }
        .padding(.horizontal, NBSpacing.standard)
    }

    private func item(
        _ symbol: String,
        _ label: String,
        enabled: Bool = true,
        action: @escaping () -> Void
    ) -> some View {
        Button {
            HapticManager.play(.light)
            action()
        } label: {
            Image(systemName: symbol)
                .font(.body.weight(.semibold))
                .frame(maxWidth: .infinity, minHeight: 50)
        }
        .buttonStyle(.plain)
        .disabled(!enabled)
        .opacity(enabled ? 1 : 0.3)
        .accessibilityLabel(label)
    }
}
