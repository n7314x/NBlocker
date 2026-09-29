import SwiftUI

struct FloatingBrowserMenuButton: View {
    let isExpanded: Bool
    let action: () -> Void

    var body: some View {
        Button {
            HapticManager.play(.light)
            action()
        } label: {
            Image(systemName: isExpanded ? "xmark" : "line.3.horizontal")
                .font(.system(size: 17, weight: .bold))
                .frame(width: 54, height: 54)
                .contentTransition(.symbolEffect(.replace))
        }
        .buttonStyle(.plain)
        .glassEffect(.regular.interactive(), in: Circle())
        .shadow(color: Color.black.opacity(0.45), radius: 14, y: 7)
        .shadow(color: Color.accentColor.opacity(0.18), radius: 10)
        .accessibilityLabel(isExpanded ? "Close browser controls" : "Browser controls")
        .accessibilityIdentifier("browser.controls")
    }
}
