import SwiftUI

enum NBAnimation {
    static let quick = Animation.easeOut(duration: 0.18)
    static let interactive = Animation.spring(response: 0.34, dampingFraction: 0.84)
    static let content = Animation.spring(response: 0.46, dampingFraction: 0.9)
}
