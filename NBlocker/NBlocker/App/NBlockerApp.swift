import SwiftUI

@main
struct NBlockerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @Environment(\.scenePhase) private var scenePhase
    @State private var environment = AppEnvironment()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(environment)
                .preferredColorScheme(.dark)
        }
        .onChange(of: scenePhase) { _, newValue in
            if newValue != .active {
                environment.usageTracker.end()
            }
        }
    }
}
