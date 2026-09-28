import SwiftUI

struct ProfileView: View {
    @Environment(AppEnvironment.self) private var environment

    var body: some View {
        ScrollView {
            VStack(spacing: NBSpacing.large) {
                VStack(spacing: NBSpacing.small) {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 58, weight: .regular))
                        .foregroundStyle(Color.accentColor)
                        .frame(width: 96, height: 96)
                        .glassEffect(
                            .regular.tint(Color.accentColor.opacity(0.18)),
                            in: Circle()
                        )

                    Text("Local profile")
                        .font(.title3.weight(.semibold))

                    Text("Your settings stay on this device")
                        .font(.subheadline)
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
            .padding(.horizontal, NBSpacing.standard)
            .padding(.top, NBSpacing.medium)
            .padding(.bottom, NBSpacing.large)
        }
        .scrollIndicators(.hidden)
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
