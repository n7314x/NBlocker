import UIKit

enum AppIconError: LocalizedError {
    case unsupported

    var errorDescription: String? {
        "Alternate icons are unavailable in this build. Add the icon artwork and bundle declarations first."
    }
}

@MainActor
struct AppIconManager {
    var supportsAlternateIcons: Bool { UIApplication.shared.supportsAlternateIcons }
    var currentName: String? { UIApplication.shared.alternateIconName }

    func select(_ option: AppIconOption) async throws {
        guard option == .defaultIcon || supportsAlternateIcons else {
            throw AppIconError.unsupported
        }
        try await UIApplication.shared.setAlternateIconName(option.alternateName)
    }
}
