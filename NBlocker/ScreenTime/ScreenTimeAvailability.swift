import Foundation

enum ScreenTimeCapabilityState: Equatable, Sendable {
    case notProvisioned
    case notDetermined
    case denied
    case approved
    case unavailable(reason: String)

    var title: String {
        switch self {
        case .notProvisioned: "Capability not provisioned"
        case .notDetermined: "Ready to request access"
        case .denied: "Access denied"
        case .approved: "Protection available"
        case .unavailable: "Unavailable"
        }
    }

    var explanation: String {
        switch self {
        case .notProvisioned:
            "This build has no Family Controls entitlement. Web filtering still works normally."
        case .notDetermined:
            "This entitled build can ask iOS for Screen Time authorization."
        case .denied:
            "iOS did not authorize Screen Time controls. You can continue using web filtering."
        case .approved:
            "iOS has authorized the provisioned Screen Time capability."
        case let .unavailable(reason):
            reason
        }
    }
}
