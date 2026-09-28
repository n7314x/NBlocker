import SwiftUI

struct InstagramSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var settings: InstagramSettings
    @State private var confirmsSiteDataClear = false
    let save: (InstagramSettings) -> Void

    init(settings: InstagramSettings, save: @escaping (InstagramSettings) -> Void) {
        _settings = State(initialValue: settings)
        self.save = save
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: NBSpacing.large) {
                    HStack(spacing: NBSpacing.medium) {
                        NBPlatformIcon(platform: .instagram, size: 58)
                        VStack(alignment: .leading, spacing: 3) {
                            Text("Instagram Settings").font(.title2.bold())
                            Text("Keep connection, reduce loops")
                                .font(.subheadline)
                                .foregroundStyle(NBColor.secondaryText)
                        }
                        Spacer()
                    }

                    InstagramBlockingSettingsView(settings: $settings)
                    InstagramReelsSettingsView(settings: $settings)
                    InstagramFeedSettingsView(settings: $settings)
                    InstagramStoriesSettingsView(settings: $settings)
                    InstagramMessagesSettingsView(settings: $settings)
                    InstagramSearchSettingsView(settings: $settings)
                    InstagramProfileSettingsView(settings: $settings)
                    InstagramAppearanceSettingsView(settings: $settings)
                    InstagramScrollSettingsView(settings: $settings)

                    NBCard {
                        VStack(alignment: .leading, spacing: NBSpacing.medium) {
                            NBSectionHeader(title: "Accounts & Site Data", subtitle: "Authentication remains in WebKit")
                            Button("Clear Instagram site data", role: .destructive) {
                                confirmsSiteDataClear = true
                            }
                        }
                    }
                }
                .padding(NBSpacing.standard)
            }
            .background(Color.black)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        save(settings)
                        dismiss()
                    }
                    .buttonStyle(.glassProminent)
                }
            }
            .confirmationDialog("Clear Instagram login and website data?", isPresented: $confirmsSiteDataClear) {
                Button("Clear Website Data", role: .destructive) {
                    Task { await CookieManager.clearWebsiteData(for: .instagram) }
                }
            } message: {
                Text("This signs Instagram out. NBlocker never reads the credentials being removed.")
            }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
        .onDisappear { save(settings) }
        .accessibilityIdentifier("settings.instagram")
    }
}
