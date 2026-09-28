import SwiftUI

struct HomeView: View {
    @Environment(AppEnvironment.self) private var environment
    @State private var platform: Platform = .instagram

    var body: some View {
        @Bindable var router = environment.router
        let stats = environment.usage.statistics(for: platform)

        ScrollView {
            VStack(spacing: NBSpacing.medium) {
                HStack(spacing: NBSpacing.small) {
                    Text("NBlocker")
                        .font(NBTypography.pageTitle)

                    Spacer()

                    Button {
                        router.selectedTab = .protection
                        HapticManager.play(.light)
                    } label: {
                        Image(systemName: "scope")
                            .font(.system(size: 15, weight: .semibold))
                            .frame(width: 34, height: 34)
                    }
                    .buttonStyle(.glass)
                    .tint(platform.accentColor)
                    .accessibilityLabel("Focus")
                    .accessibilityIdentifier("home.focus")
                }

                PlatformUsageView(platform: platform, statistics: stats)

                Button("See activity") {
                    router.selectedTab = .activity
                    HapticManager.play(.light)
                }
                .font(.caption.weight(.semibold))
                .foregroundStyle(platform.accentColor)

                PlatformCarouselView(platform: $platform) { selected in
                    router.presentedBrowser = selected
                    HapticManager.play(.light)
                }

                Button {
                    router.presentedSettings = platform
                } label: {
                    NBCard {
                        HStack(spacing: NBSpacing.medium) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(platform.settingsTitle)
                                    .font(.subheadline.weight(.semibold))
                                Text("Choose what stays useful and what disappears")
                                    .font(.caption2)
                                    .foregroundStyle(NBColor.secondaryText)
                            }

                            Spacer()

                            Image(systemName: "slider.horizontal.3")
                                .font(.subheadline)
                                .foregroundStyle(platform.accentColor)
                        }
                    }
                }
                .buttonStyle(.plain)
                .accessibilityIdentifier("home.platformSettings")

                CurrentRoutineCard(routine: environment.routines.activeRoutine())
            }
            .padding(.horizontal, NBSpacing.standard)
            .padding(.top, NBSpacing.small)
            .padding(.bottom, NBSpacing.medium)
        }
        .scrollIndicators(.hidden)
        .background {
            RadialGradient(
                colors: [platform.accentColor.opacity(0.10), .clear],
                center: .top,
                startRadius: 0,
                endRadius: 300
            )
            .ignoresSafeArea()
            .animation(NBAnimation.content, value: platform)
        }
        .toolbar(.hidden, for: .navigationBar)
        .accessibilityIdentifier("screen.home")
    }
}
