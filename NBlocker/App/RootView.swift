import SwiftUI

struct RootView: View {
    @Environment(AppEnvironment.self) private var environment
    @AppStorage("appearance.reduceNativeMotion") private var reduceNativeMotion = false

    var body: some View {
        @Bindable var router = environment.router

        ZStack {
            NBColor.canvas.ignoresSafeArea()

            Group {
                switch router.selectedTab {
                case .sleep:
                    NavigationStack { SleepView() }
                case .activity:
                    NavigationStack { ActivityView() }
                case .home:
                    NavigationStack { HomeView() }
                case .protection:
                    NavigationStack { ProtectionView() }
                case .profile:
                    NavigationStack { ProfileView() }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .safeAreaInset(edge: .bottom, spacing: 4) {
            NBBottomBar(selection: $router.selectedTab)
        }
        .fullScreenCover(item: $router.presentedBrowser) { platform in
            switch platform {
            case .instagram:
                InstagramView(
                    settings: environment.settings.values,
                    usageTracker: environment.usageTracker
                )
            case .youtube:
                YouTubeView(
                    settings: environment.settings.values,
                    usageTracker: environment.usageTracker
                )
            }
        }
        .sheet(item: $router.presentedSettings) { platform in
            switch platform {
            case .instagram:
                InstagramSettingsView(settings: environment.settings.values.instagram) {
                    environment.settings.replaceInstagram(with: $0)
                }
            case .youtube:
                YouTubeSettingsView(settings: environment.settings.values.youtube) {
                    environment.settings.replaceYouTube(with: $0)
                }
            }
        }
        .transaction { transaction in
            if reduceNativeMotion {
                transaction.disablesAnimations = true
            }
        }
    }
}
