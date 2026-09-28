import SwiftUI

struct ProfileView: View {
    @Environment(AppEnvironment.self) private var environment

    var body: some View {
        ScrollView {
            VStack(spacing: NBSpacing.large) {
                NBSectionHeader(title: "Profile", subtitle: "No NBlocker account required")
                VStack(spacing: NBSpacing.small) {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 72))
                        .foregroundStyle(Color.accentColor)
                    Text("Local profile").font(.title3.weight(.semibold))
                    Text("Your settings stay on this device")
                        .font(.caption)
                        .foregroundStyle(NBColor.secondaryText)
                }
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
            .padding(NBSpacing.standard)
        }
        .navigationTitle("Profile")
        .toolbarTitleDisplayMode(.inline)
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
