import SwiftUI

struct NBSectionHeader: View {
    let title: String
    var subtitle: String?

    var body: some View {
        VStack(alignment: .leading, spacing: NBSpacing.xSmall) {
            Text(title).font(NBTypography.sectionTitle)
            if let subtitle {
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(NBColor.secondaryText)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
    }
}

struct NBScreenHeader<Trailing: View>: View {
    let title: String
    var subtitle: String?
    @ViewBuilder let trailing: Trailing

    init(
        _ title: String,
        subtitle: String? = nil,
        @ViewBuilder trailing: () -> Trailing
    ) {
        self.title = title
        self.subtitle = subtitle
        self.trailing = trailing()
    }

    var body: some View {
        HStack(alignment: .top, spacing: NBSpacing.medium) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(NBTypography.pageTitle)
                    .foregroundStyle(.white)

                if let subtitle {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(NBColor.secondaryText)
                }
            }

            Spacer(minLength: NBSpacing.small)
            trailing
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

extension NBScreenHeader where Trailing == EmptyView {
    init(_ title: String, subtitle: String? = nil) {
        self.init(title, subtitle: subtitle) { EmptyView() }
    }
}
