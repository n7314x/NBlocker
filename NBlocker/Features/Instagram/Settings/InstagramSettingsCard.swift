import SwiftUI

struct InstagramSettingsCard<Content: View>: View {
    @ViewBuilder let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(NBSpacing.standard)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background {
                RoundedRectangle(cornerRadius: NBRadius.prominent, style: .continuous)
                    .fill(NBColor.card)
                    .overlay {
                        LinearGradient(
                            colors: [Color.white.opacity(0.035), .clear],
                            startPoint: .top,
                            endPoint: .center
                        )
                        .clipShape(RoundedRectangle(cornerRadius: NBRadius.prominent, style: .continuous))
                        .allowsHitTesting(false)
                    }
            }
            .overlay {
                RoundedRectangle(cornerRadius: NBRadius.prominent, style: .continuous)
                    .stroke(
                        LinearGradient(
                            colors: [Color.white.opacity(0.14), Color.white.opacity(0.045)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 0.7
                    )
                    .allowsHitTesting(false)
            }
            .shadow(color: .black.opacity(0.22), radius: 12, y: 6)
    }
}
