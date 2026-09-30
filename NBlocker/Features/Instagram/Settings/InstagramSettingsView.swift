import SwiftUI

struct InstagramSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var settings: InstagramSettings
    @State private var confirmsSiteDataClear = false
    @State private var selectedDetent: PresentationDetent = .fraction(0.58)
    let save: (InstagramSettings) -> Void

    init(settings: InstagramSettings, save: @escaping (InstagramSettings) -> Void) {
        _settings = State(initialValue: settings)
        self.save = save
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: NBSpacing.xLarge) {
                InstagramSettingsHeader(filteringEnabled: settings.filteringEnabled) {
                    save(settings)
                    dismiss()
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

                InstagramSettingsSection(
                    "Accounts & Site Data",
                    subtitle: "Instagram authentication stays in WebKit"
                ) {
                    VStack(alignment: .leading, spacing: 0) {
                        Button(role: .destructive) {
                            confirmsSiteDataClear = true
                        } label: {
                            Label("Clear Instagram site data", systemImage: "trash")
                                .font(.subheadline.weight(.semibold))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .frame(minHeight: 44)
                        }
                    }
                }
            }
            .padding(.horizontal, NBSpacing.screen)
            .padding(.top, NBSpacing.small)
            .padding(.bottom, 44)
        }
        .scrollIndicators(.hidden)
        .scrollBounceBehavior(.basedOnSize)
        .background {
            ZStack {
                NBColor.sheet
                RadialGradient(
                    colors: [Platform.instagram.accentColor.opacity(0.08), .clear],
                    center: .top,
                    startRadius: 0,
                    endRadius: 380
                )
                .allowsHitTesting(false)
            }
        }
        .toggleStyle(NBLiquidGlassToggleStyle(tint: Platform.instagram.accentColor))
        .confirmationDialog("Clear Instagram login and website data?", isPresented: $confirmsSiteDataClear) {
            Button("Clear Website Data", role: .destructive) {
                Task { await CookieManager.clearWebsiteData(for: .instagram) }
            }
        } message: {
            Text("This signs Instagram out. NBlocker never reads the credentials being removed.")
        }
        .presentationDetents([.fraction(0.58), .large], selection: $selectedDetent)
        .presentationDragIndicator(.hidden)
        .presentationCornerRadius(NBRadius.sheet)
        .presentationBackground(NBColor.sheet)
        .presentationContentInteraction(.resizes)
        .onDisappear { save(settings) }
        .accessibilityIdentifier("settings.instagram")
    }
}
