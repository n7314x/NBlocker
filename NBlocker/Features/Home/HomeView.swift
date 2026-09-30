import SwiftUI

struct HomeView: View {
    @Environment(AppEnvironment.self) private var environment
    @State private var platform: Platform = .instagram

    var body: some View {
        @Bindable var router = environment.router
        let stats = environment.usage.statistics(for: platform)

        NBRootScrollView {
            NBScreenHeader("NBlocker") {
                Button {
                    router.selectedTab = .protection
                    HapticManager.play(.light)
                } label: {
                    Label("Protect", systemImage: "shield.fill")
                        .font(.subheadline.weight(.semibold))
                        .padding(.horizontal, NBSpacing.small)
                        .frame(minHeight: 38)
                }
                .buttonStyle(.glass)
                .controlSize(.small)
                .tint(platform.accentColor)
                .accessibilityIdentifier("home.focus")
            }

            VStack(spacing: NBSpacing.small) {
                PlatformUsageView(platform: platform, statistics: stats)

                Button {
                    router.selectedTab = .activity
                    HapticManager.play(.light)
                } label: {
                    Label("See activity", systemImage: "chevron.right")
                        .labelStyle(.titleAndIcon)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(NBColor.secondaryText)
                }
                .accessibilityIdentifier("home.seeActivity")
            }
            .frame(maxWidth: .infinity)

            PlatformCarouselView(platform: $platform) { selected in
                router.presentedBrowser = selected
                HapticManager.play(.light)
            }

            Button {
                router.presentedSettings = platform
            } label: {
                NBCard {
                    HStack(spacing: NBSpacing.standard) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(platform.settingsTitle)
                                .font(.headline.weight(.semibold))
                            Text("Choose what stays useful")
                                .font(.subheadline)
                                .foregroundStyle(NBColor.secondaryText)
                        }

                        Spacer()

                        Image(systemName: "slider.horizontal.3")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(width: 46, height: 46)
                            .glassEffect(
                                .regular.tint(platform.accentColor.opacity(0.24)).interactive(),
                                in: Circle()
                            )
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
                endRadius: 340
            )
            .ignoresSafeArea()
            .allowsHitTesting(false)
            .animation(NBAnimation.content, value: platform)
        }
        .toolbar(.hidden, for: .navigationBar)
        .accessibilityIdentifier("screen.home")
    }
}
