import SwiftUI

struct NBSectionHeader: View {
    let title: String
    var subtitle: String?

    var body: some View {
        VStack(alignment: .leading, spacing: NBSpacing.xSmall) {
            Text(title).font(NBTypography.sectionTitle)
            if let subtitle {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(NBColor.secondaryText)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
    }
}
