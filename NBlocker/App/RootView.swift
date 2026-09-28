import SwiftUI

struct RootView: View {
    @Environment(AppEnvironment.self) private var environment
    @AppStorage("appearance.reduceNativeMotion") private var reduceNativeMotion = false

    var body: some View {
        @Bindable var router = environment.router

        TabView(selection: $router.selectedTab) {
            Tab("Sleep", systemImage: RootTab.sleep.symbolName, value: RootTab.sleep) {
                NavigationStack {
                    SleepView()
                }
            }

            Tab("Activity", systemImage: RootTab.activity.symbolName, value: RootTab.activity) {
                NavigationStack {
                    ActivityView()
                }
            }

            Tab("Home", systemImage: RootTab.home.symbolName, value: RootTab.home) {
                NavigationStack {
                    HomeView()
                }
            }

            Tab("Protection", systemImage: RootTab.protection.symbolName, value: RootTab.protection) {
                NavigationStack {
                    ProtectionView()
                }
            }

            Tab("Profile", systemImage: RootTab.profile.symbolName, value: RootTab.profile) {
                NavigationStack {
                    ProfileView()
                }
            }
        }
        .tint(Color.accentColor)
        .background(NBColor.canvas.ignoresSafeArea())
        .onChange(of: router.selectedTab) { oldValue, newValue in
            guard oldValue != newValue else { return }
            HapticManager.play(.selection)
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
