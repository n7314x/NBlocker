import SwiftUI

enum NBAnimation {
    static let quick = Animation.easeOut(duration: 0.16)
    static let interactive = Animation.spring(response: 0.32, dampingFraction: 0.86)
    static let content = Animation.spring(response: 0.42, dampingFraction: 0.9)
}
