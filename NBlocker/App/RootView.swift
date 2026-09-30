import SwiftUI

struct RootView: View {
    @Environment(AppEnvironment.self) private var environment
    @AppStorage("appearance.reduceNativeMotion") private var reduceNativeMotion = false

    var body: some View {
        @Bindable var router = environment.router

        TabView(selection: $router.selectedTab) {
            Tab(value: RootTab.sleep) {
                NavigationStack {
                    SleepView()
                }
            } label: {
                rootTabLabel(.sleep)
            }

            Tab(value: RootTab.activity) {
                NavigationStack {
                    ActivityView()
                }
            } label: {
                rootTabLabel(.activity)
            }

            Tab(value: RootTab.home) {
                NavigationStack {
                    HomeView()
                }
            } label: {
                rootTabLabel(.home)
            }

            Tab(value: RootTab.protection) {
                NavigationStack {
                    ProtectionView()
                }
            } label: {
                rootTabLabel(.protection)
            }

            Tab(value: RootTab.profile) {
                NavigationStack {
                    ProfileView()
                }
            } label: {
                rootTabLabel(.profile)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(NBColor.canvas.ignoresSafeArea())
        .tint(Color.accentColor)
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

    private func rootTabLabel(_ tab: RootTab) -> some View {
        Label(
            tab.title,
            systemImage: environment.router.selectedTab == tab ? tab.selectedSymbolName : tab.symbolName
        )
            .labelStyle(.iconOnly)
            .accessibilityLabel(tab.title)
    }
}
