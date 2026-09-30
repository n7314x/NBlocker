import SwiftUI

struct ProtectedAppsView: View {
    let state: ScreenTimeCapabilityState

    var body: some View {
        NBCard {
            VStack(alignment: .leading, spacing: NBSpacing.standard) {
                HStack {
                    Label("System App Protection", systemImage: "square.grid.2x2.fill")
                        .font(.headline.weight(.semibold))
                    Spacer()
                    Text("0 selected")
                        .font(.caption)
                        .foregroundStyle(NBColor.secondaryText)
                }
                Text(state.explanation)
                    .font(.subheadline)
                    .foregroundStyle(NBColor.secondaryText)

                Button {} label: {
                    Label("Manage Apps", systemImage: "slider.horizontal.3")
                        .font(.subheadline.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .frame(height: 46)
                }
                .buttonStyle(.glass)
                    .disabled(state != .approved)
            }
        }
    }
}
