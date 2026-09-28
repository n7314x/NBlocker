import SwiftUI

struct NBCard<Content: View>: View {
    @ViewBuilder let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(NBSpacing.standard)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(NBColor.card, in: RoundedRectangle(cornerRadius: NBRadius.card, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: NBRadius.card, style: .continuous)
                    .stroke(NBColor.border, lineWidth: 1)
            }
    }
}
