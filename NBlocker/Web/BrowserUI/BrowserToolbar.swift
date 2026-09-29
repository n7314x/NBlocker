import SwiftUI

struct BrowserToolbar: View {
    @Binding var position: CGPoint?
    let restingPosition: CGPoint
    let movementBounds: CGRect
    let isExpanded: Bool
    let menuWillClose: () -> Void
    let action: () -> Void

    var body: some View {
        FloatingBrowserMenuButton(
            position: $position,
            restingPosition: restingPosition,
            movementBounds: movementBounds,
            isExpanded: isExpanded,
            menuWillClose: menuWillClose,
            action: action
        )
    }
}
