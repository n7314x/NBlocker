import SwiftUI

struct ProfileView: View {
    @Environment(AppEnvironment.self) private var environment

    var body: some View {
        NBRootScrollView(spacing: NBSpacing.xLarge) {
            NBScreenHeader("Profile")

            VStack(spacing: NBSpacing.small) {
                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 48, weight: .regular))
                    .foregroundStyle(Color.accentColor)
                    .frame(width: 82, height: 82)
                    .glassEffect(
                        .regular.tint(Color.accentColor.opacity(0.14)),
                        in: Circle()
                    )

                Text("Local profile")
                    .font(.title2.weight(.semibold))

                Label("Stored only on this device", systemImage: "lock.fill")
                    .font(.subheadline)
                    .foregroundStyle(NBColor.secondaryText)
            }
            .frame(maxWidth: .infinity)

            ProfileStatsView(usage: environment.usage.statistics())

            VStack(spacing: NBSpacing.standard) {
                profileLink("Appearance", "circle.lefthalf.filled") { AppearanceSettingsView() }
                profileLink("Notifications", "bell.fill") { NotificationSettingsView() }
                profileLink("Privacy", "hand.raised.fill") { PrivacySettingsView() }
                profileLink("App Icons", "app.dashed") { AppIconPickerView() }
                profileLink("Data & Debug", "externaldrive.fill") { DebugSettingsView() }
                profileLink("About NBlocker", "questionmark.circle.fill") { AboutView() }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .accessibilityIdentifier("screen.profile")
    }

    private func profileLink<Destination: View>(
        _ title: String,
        _ symbol: String,
        @ViewBuilder destination: () -> Destination
    ) -> some View {
        NavigationLink(destination: destination) {
            NBCard(padding: NBSpacing.standard) {
                NBSettingRow(symbol: symbol, title: title)
            }
        }
        .buttonStyle(NBSpringPressButtonStyle())
    }
}
