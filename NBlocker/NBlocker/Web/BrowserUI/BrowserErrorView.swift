import SwiftUI

struct BrowserErrorView: View {
    let message: String
    let dismiss: () -> Void

    var body: some View {
        HStack(spacing: NBSpacing.medium) {
            Image(systemName: "hand.raised.fill").foregroundStyle(NBColor.warning)
            Text(message).font(.subheadline).lineLimit(3)
            Spacer(minLength: 0)
            Button("OK", action: dismiss).font(.subheadline.weight(.semibold))
        }
        .padding(NBSpacing.standard)
        .background(NBColor.cardRaised, in: RoundedRectangle(cornerRadius: NBRadius.card, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: NBRadius.card, style: .continuous)
                .stroke(NBColor.border, lineWidth: 1)
        }
    }
}
