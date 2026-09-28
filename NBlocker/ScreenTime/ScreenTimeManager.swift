import Observation

@MainActor
@Observable
final class ScreenTimeCapabilityService {
    private(set) var state: ScreenTimeCapabilityState = .notProvisioned

    var canManageApps: Bool {
        state == .approved
    }

    func refresh() {
        // The default app target intentionally has no FamilyControls entitlement.
        // An entitled adapter will replace this implementation in a future flavor.
        state = .notProvisioned
    }
}
