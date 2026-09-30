import SwiftUI

struct NBCard<Content: View>: View {
    var padding: CGFloat
    @ViewBuilder let content: Content

    init(padding: CGFloat = NBSpacing.large, @ViewBuilder content: () -> Content) {
        self.padding = padding
        self.content = content()
    }

    var body: some View {
        content
            .padding(padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(NBColor.card, in: RoundedRectangle(cornerRadius: NBRadius.card, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: NBRadius.card, style: .continuous)
                    .stroke(NBColor.border, lineWidth: 1)
                    .allowsHitTesting(false)
            }
    }
}
