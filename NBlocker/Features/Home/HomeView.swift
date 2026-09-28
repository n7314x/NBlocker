import SwiftUI

struct HomeView: View {
    @Environment(AppEnvironment.self) private var environment
    @State private var platform: Platform = .instagram

    var body: some View {
        @Bindable var router = environment.router
        let stats = environment.usage.statistics(for: platform)

        ScrollView {
            VStack(spacing: NBSpacing.large) {
                PlatformUsageView(platform: platform, statistics: stats)

                Button("See activity") {
                    router.selectedTab = .activity
                    HapticManager.play(.light)
                }
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(platform.accentColor)

                PlatformCarouselView(platform: $platform) { selected in
                    router.presentedBrowser = selected
                    HapticManager.play(.light)
                }

                Button {
                    router.presentedSettings = platform
                } label: {
                    NBCard {
                        HStack {
                            VStack(alignment: .leading, spacing: NBSpacing.xSmall) {
                                Text(platform.settingsTitle)
                                    .font(.headline)
                                Text("Choose what stays useful and what disappears")
                                    .font(.subheadline)
                                    .foregroundStyle(NBColor.secondaryText)
                            }
                            Spacer()
                            Image(systemName: "slider.horizontal.3")
                                .foregroundStyle(platform.accentColor)
                        }
                    }
                }
                .buttonStyle(.plain)
                .accessibilityIdentifier("home.platformSettings")

                CurrentRoutineCard(routine: environment.routines.activeRoutine())
            }
            .padding(.horizontal, NBSpacing.standard)
            .padding(.top, NBSpacing.medium)
            .padding(.bottom, NBSpacing.large)
        }
        .scrollIndicators(.hidden)
        .background {
            RadialGradient(
                colors: [platform.accentColor.opacity(0.12), .clear],
                center: .top,
                startRadius: 0,
                endRadius: 360
            )
            .ignoresSafeArea()
            .animation(NBAnimation.content, value: platform)
        }
        .navigationTitle("NBlocker")
        .toolbarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    router.selectedTab = .protection
                    HapticManager.play(.light)
                } label: {
                    Label("Focus", systemImage: "scope")
                }
                .accessibilityIdentifier("home.focus")
            }
        }
        .accessibilityIdentifier("screen.home")
    }
}
