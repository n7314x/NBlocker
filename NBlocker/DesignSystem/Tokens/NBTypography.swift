import SwiftUI

enum NBTypography {
    static let pageTitle = Font.system(.title2, design: .rounded, weight: .bold)
    static let sectionTitle = Font.system(.headline, design: .rounded, weight: .semibold)
    static let usageValue = Font.system(size: 38, weight: .semibold, design: .rounded).monospacedDigit()
    static let label = Font.system(.footnote, design: .rounded, weight: .medium)
}
