import SwiftUI

struct NBPlatformIcon: View {
    let platform: Platform
    var size: CGFloat = 62

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: size * 0.25, style: .continuous)
                .fill(NBColor.cardRaised)

            RoundedRectangle(cornerRadius: size * 0.25, style: .continuous)
                .stroke(platform.accentColor.opacity(0.42), lineWidth: 0.8)

            Image(systemName: platform.symbolName)
                .font(.system(size: size * 0.36, weight: .semibold))
                .foregroundStyle(platform.accentColor)
        }
        .frame(width: size, height: size)
        .shadow(color: platform.accentColor.opacity(0.16), radius: 10)
        .accessibilityLabel(platform.displayName)
    }
}
