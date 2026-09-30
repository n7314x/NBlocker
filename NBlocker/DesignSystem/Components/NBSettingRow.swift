import SwiftUI

struct NBSettingRow<Trailing: View>: View {
    let symbol: String
    let title: String
    var subtitle: String?
    @ViewBuilder let trailing: Trailing

    init(
        symbol: String,
        title: String,
        subtitle: String? = nil,
        @ViewBuilder trailing: () -> Trailing
    ) {
        self.symbol = symbol
        self.title = title
        self.subtitle = subtitle
        self.trailing = trailing()
    }

    var body: some View {
        HStack(spacing: NBSpacing.medium) {
            Image(systemName: symbol)
                .font(.system(size: 17, weight: .semibold))
                .frame(width: 26)
                .foregroundStyle(.tint)

            VStack(alignment: .leading, spacing: 1) {
                Text(title)
                    .font(.body.weight(.medium))
                if let subtitle {
                    Text(subtitle)
                        .font(.caption2)
                        .foregroundStyle(NBColor.secondaryText)
                }
            }

            Spacer(minLength: NBSpacing.small)
            trailing
        }
        .frame(minHeight: 48)
        .contentShape(Rectangle())
    }
}

struct NBDisclosureIndicator: View {
    var body: some View {
        Image(systemName: "chevron.right")
            .font(.caption2.weight(.semibold))
            .foregroundStyle(NBColor.quietText)
    }
}

extension NBSettingRow where Trailing == NBDisclosureIndicator {
    init(symbol: String, title: String, subtitle: String? = nil) {
        self.init(symbol: symbol, title: title, subtitle: subtitle) {
            NBDisclosureIndicator()
        }
    }
}
