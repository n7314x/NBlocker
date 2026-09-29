import SwiftUI

struct ProtectedAppsView: View {
    let state: ScreenTimeCapabilityState

    var body: some View {
        NBCard {
            VStack(alignment: .leading, spacing: NBSpacing.medium) {
                HStack {
                    Label("Protected Apps", systemImage: "square.grid.2x2.fill")
                        .font(.subheadline.weight(.semibold))
                    Spacer()
                    Text("0 selected")
                        .font(.caption)
                        .foregroundStyle(NBColor.secondaryText)
                }
                Text(state.explanation)
                    .font(.caption)
                    .foregroundStyle(NBColor.secondaryText)
                Button("Manage Apps") {}
                    .buttonStyle(.glassProminent)
                    .controlSize(.small)
                    .disabled(state != .approved)
            }
        }
    }
}
