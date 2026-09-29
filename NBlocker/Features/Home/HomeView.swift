import SwiftUI

struct HomeView: View {
    @Environment(AppEnvironment.self) private var environment
    @State private var platform: Platform = .instagram

    var body: some View {
        @Bindable var router = environment.router
        let stats = environment.usage.statistics(for: platform)

        NBRootScrollView {
            HStack(spacing: NBSpacing.small) {
                Text("NBlocker")
                    .font(NBTypography.pageTitle)

                Spacer()

                Button {
                    router.selectedTab = .protection
                    HapticManager.play(.light)
                } label: {
                    Label("Focus", systemImage: "scope")
                        .font(.caption.weight(.semibold))
                }
                .buttonStyle(.glass)
                .controlSize(.small)
                .tint(platform.accentColor)
                .accessibilityIdentifier("home.focus")
            }

            PlatformUsageView(platform: platform, statistics: stats)
                .frame(maxWidth: .infinity)

            Button("See activity") {
                router.selectedTab = .activity
                HapticManager.play(.light)
            }
            .font(.caption.weight(.semibold))
            .foregroundStyle(platform.accentColor)
            .frame(maxWidth: .infinity)
            .accessibilityIdentifier("home.seeActivity")

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
        .background {
            RadialGradient(
                colors: [platform.accentColor.opacity(0.10), .clear],
                center: .top,
                startRadius: 0,
                endRadius: 260
            )
            .ignoresSafeArea()
            .allowsHitTesting(false)
            .animation(NBAnimation.content, value: platform)
        }
        .toolbar(.hidden, for: .navigationBar)
        .accessibilityIdentifier("screen.home")
    }
}
