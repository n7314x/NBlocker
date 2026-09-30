import SwiftUI

enum NBTypography {
    static let pageTitle = Font.system(.largeTitle, design: .rounded, weight: .semibold)
    static let sectionTitle = Font.system(.title3, design: .rounded, weight: .semibold)
    static let usageValue = Font.system(size: 42, weight: .medium, design: .rounded).monospacedDigit()
    static let label = Font.system(.footnote, design: .rounded, weight: .medium)
}
