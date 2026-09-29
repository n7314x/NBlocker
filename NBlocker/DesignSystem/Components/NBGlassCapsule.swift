import SwiftUI

struct NBGlassCapsule: View {
    let symbol: String
    let title: String
    var tint: Color = .accentColor

    var body: some View {
        Label(title, systemImage: symbol)
            .font(.caption.weight(.semibold))
            .padding(.horizontal, NBSpacing.medium)
            .frame(minHeight: 36)
            .glassEffect(.regular.tint(tint.opacity(0.32)))
    }
}
