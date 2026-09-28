import SwiftUI

struct YouTubeSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var settings: YouTubeSettings
    @State private var confirmsSiteDataClear = false
    let save: (YouTubeSettings) -> Void

    init(settings: YouTubeSettings, save: @escaping (YouTubeSettings) -> Void) {
        _settings = State(initialValue: settings)
        self.save = save
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: NBSpacing.large) {
                    HStack(spacing: NBSpacing.medium) {
                        NBPlatformIcon(platform: .youtube, size: 58)
                        VStack(alignment: .leading, spacing: 3) {
                            Text("YouTube Settings").font(.title2.bold())
                            Text("Preserve search and long-form playback")
                                .font(.subheadline)
                                .foregroundStyle(NBColor.secondaryText)
                        }
                        Spacer()
                    }

                    NBCard {
                        NBToggleRow(title: "Enable filtering", detail: "Applies the selected page rules", isOn: $settings.filteringEnabled)
                    }
                    YouTubeShortsSettingsView(settings: $settings)
                    YouTubeFeedSettingsView(settings: $settings)
                    YouTubePlaybackSettingsView(settings: $settings)
                    YouTubeSearchSettingsView(settings: $settings)
                    YouTubeCommentsSettingsView(settings: $settings)
                    YouTubeAppearanceSettingsView(settings: $settings)

                    NBCard {
                        VStack(alignment: .leading, spacing: NBSpacing.medium) {
                            NBSectionHeader(title: "Accounts & Site Data", subtitle: "Google authentication remains in WebKit")
                            Button("Clear YouTube site data", role: .destructive) {
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
            .confirmationDialog("Clear YouTube and Google website data?", isPresented: $confirmsSiteDataClear) {
                Button("Clear Website Data", role: .destructive) {
                    Task { await CookieManager.clearWebsiteData(for: .youtube) }
                }
            } message: {
                Text("This can sign YouTube out. NBlocker never reads the credentials being removed.")
            }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
        .onDisappear { save(settings) }
        .accessibilityIdentifier("settings.youtube")
    }
}
