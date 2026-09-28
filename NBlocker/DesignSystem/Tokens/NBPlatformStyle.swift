import SwiftUI

extension Platform {
    var accentColor: Color {
        switch self {
        case .instagram: Color(red: 0.95, green: 0.27, blue: 0.56)
        case .youtube: Color(red: 1.0, green: 0.18, blue: 0.2)
        }
    }

    var secondaryAccentColor: Color {
        switch self {
        case .instagram: Color(red: 0.51, green: 0.29, blue: 0.96)
        case .youtube: Color(red: 0.7, green: 0.05, blue: 0.08)
        }
    }
}
