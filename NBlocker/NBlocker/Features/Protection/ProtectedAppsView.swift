import SwiftUI

struct ProtectedAppsView: View {
    let state: ScreenTimeCapabilityState

    var body: some View {
        NBCard {
            VStack(alignment: .leading, spacing: NBSpacing.standard) {
                HStack {
                    Label("Protected Apps", systemImage: "square.grid.2x2.fill")
                        .font(.headline)
                    Spacer()
                    Text("0 selected")
                        .font(.caption)
                        .foregroundStyle(NBColor.secondaryText)
                }
                Text(state.explanation)
                    .font(.subheadline)
                    .foregroundStyle(NBColor.secondaryText)
                Button("Manage Apps") {}
                    .buttonStyle(.borderedProminent)
                    .disabled(state != .approved)
            }
        }
    }
}
