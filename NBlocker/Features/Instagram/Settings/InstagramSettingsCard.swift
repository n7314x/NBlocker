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
            }
            .overlay {
                RoundedRectangle(cornerRadius: NBRadius.prominent, style: .continuous)
                    .stroke(
                        LinearGradient(
                        colors: [Color.white.opacity(0.20), Color.white.opacity(0.08)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                    lineWidth: 1
                    )
                    .allowsHitTesting(false)
            }
            .shadow(color: .black.opacity(0.18), radius: 10, y: 5)
    }
}

struct InstagramSettingsSection<Content: View>: View {
    let title: String
    var subtitle: String?
    @ViewBuilder let content: Content

    init(
        _ title: String,
        subtitle: String? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.subtitle = subtitle
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: NBSpacing.medium) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.title3.weight(.semibold))
                if let subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(NBColor.secondaryText)
                }
            }
            .padding(.horizontal, NBSpacing.small)

            InstagramSettingsCard {
                content
            }
        }
    }
}
