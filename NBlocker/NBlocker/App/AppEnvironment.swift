import Foundation
import Observation

@MainActor
@Observable
final class AppEnvironment {
    let settings: SettingsStore
    let routines: RoutineStore
    let usage: UsageStore
    let usageTracker: UsageTracker
    let screenTime: ScreenTimeCapabilityService
    let router: AppRouter

    init(defaults: UserDefaults = .standard) {
        let usage = UsageStore(defaults: defaults)
        self.settings = SettingsStore(defaults: defaults)
        self.routines = RoutineStore(defaults: defaults)
        self.usage = usage
        self.usageTracker = UsageTracker(store: usage)
        self.screenTime = ScreenTimeCapabilityService()
        self.router = AppRouter()
    }
}
