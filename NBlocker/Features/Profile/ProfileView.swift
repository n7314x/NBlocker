import SwiftUI

struct ProfileView: View {
    @Environment(AppEnvironment.self) private var environment

    var body: some View {
        NBRootScrollView {
            NBSectionHeader(title: "Profile", subtitle: "No NBlocker account required")

            VStack(spacing: NBSpacing.xSmall) {
                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 34, weight: .regular))
                    .foregroundStyle(Color.accentColor)
                    .frame(width: 56, height: 56)
                    .glassEffect(
                        .regular.tint(Color.accentColor.opacity(0.16)),
                        in: Circle()
                    )

                Text("Local profile")
                    .font(.subheadline.weight(.semibold))

                Text("Your settings stay on this device")
                    .font(.caption2)
                    .foregroundStyle(NBColor.secondaryText)
            }
            .frame(maxWidth: .infinity)

            ProfileStatsView(usage: environment.usage.statistics())

            NBCard {
                VStack(spacing: 0) {
                    link("Appearance", "circle.lefthalf.filled") { AppearanceSettingsView() }
                    Divider().overlay(NBColor.border)
                    link("Notifications", "bell") { NotificationSettingsView() }
                    Divider().overlay(NBColor.border)
                    link("Privacy", "hand.raised") { PrivacySettingsView() }
                    Divider().overlay(NBColor.border)
                    link("App Icons", "app.dashed") { AppIconPickerView() }
                    Divider().overlay(NBColor.border)
                    link("Data & Debug", "externaldrive") { DebugSettingsView() }
                    Divider().overlay(NBColor.border)
                    link("About", "info.circle") { AboutView() }
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .accessibilityIdentifier("screen.profile")
    }

    private func link<Destination: View>(
        _ title: String,
        _ symbol: String,
        @ViewBuilder destination: () -> Destination
    ) -> some View {
        NavigationLink(destination: destination) {
            NBSettingRow(symbol: symbol, title: title)
        }
        .buttonStyle(.plain)
    }
}
