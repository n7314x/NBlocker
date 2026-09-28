import Foundation

struct SharedProtectionSnapshot: Codable, Sendable {
    var routineName: String
    var endsAt: Date?
    var isStrict: Bool
}
