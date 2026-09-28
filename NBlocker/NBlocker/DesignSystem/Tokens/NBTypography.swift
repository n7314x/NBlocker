import SwiftUI

enum NBTypography {
    static let pageTitle = Font.system(.largeTitle, design: .rounded, weight: .bold)
    static let sectionTitle = Font.system(.title3, design: .rounded, weight: .semibold)
    static let usageValue = Font.system(size: 48, weight: .semibold, design: .rounded).monospacedDigit()
    static let label = Font.system(.subheadline, design: .rounded, weight: .medium)
}
