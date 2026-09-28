import SwiftUI

struct NBGlassCapsule: View {
    let symbol: String
    let title: String
    var tint: Color = .accentColor

    var body: some View {
        Label(title, systemImage: symbol)
            .font(.subheadline.weight(.semibold))
            .padding(.horizontal, NBSpacing.standard)
            .frame(minHeight: 40)
            .glassEffect(.regular.tint(tint.opacity(0.32)))
    }
}
