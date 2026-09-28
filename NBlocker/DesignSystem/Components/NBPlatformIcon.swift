import SwiftUI

struct NBPlatformIcon: View {
    let platform: Platform
    var size: CGFloat = 74

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: size * 0.28, style: .continuous)
                .fill(NBColor.cardRaised)
            RoundedRectangle(cornerRadius: size * 0.28, style: .continuous)
                .stroke(platform.accentColor.opacity(0.45), lineWidth: 1)
            Image(systemName: platform.symbolName)
                .font(.system(size: size * 0.38, weight: .semibold))
                .foregroundStyle(platform.accentColor)
        }
        .frame(width: size, height: size)
        .shadow(color: platform.accentColor.opacity(0.24), radius: 24)
        .accessibilityLabel(platform.displayName)
    }
}
