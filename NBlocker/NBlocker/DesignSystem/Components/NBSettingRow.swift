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
                .frame(width: 26)
                .foregroundStyle(.tint)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                if let subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(NBColor.secondaryText)
                }
            }
            Spacer(minLength: NBSpacing.small)
            trailing
        }
        .frame(minHeight: 44)
        .contentShape(Rectangle())
    }
}

extension NBSettingRow where Trailing == Image {
    init(symbol: String, title: String, subtitle: String? = nil) {
        self.init(symbol: symbol, title: title, subtitle: subtitle) {
            Image(systemName: "chevron.right")
                .font(.caption.weight(.semibold))
                .foregroundStyle(NBColor.quietText)
        }
    }
}
