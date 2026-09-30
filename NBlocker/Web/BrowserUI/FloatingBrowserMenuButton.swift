import SwiftUI

struct FloatingBrowserMenuButton: View {
    @Binding var position: CGPoint?
    let restingPosition: CGPoint
    let movementBounds: CGRect
    let isExpanded: Bool
    let menuWillClose: () -> Void
    let action: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var dragOrigin: CGPoint?
    @State private var isDragging = false

    var body: some View {
        Button {
            guard !isDragging else { return }
            HapticManager.play(.light)
            action()
        } label: {
            ZStack {
                Circle()
                    .fill(Color.accentColor.opacity(isExpanded ? 0.18 : 0.09))
                    .allowsHitTesting(false)

                Image(systemName: isExpanded ? "xmark" : "line.3.horizontal")
                    .font(.system(size: 18, weight: .bold))
                    .contentTransition(.symbolEffect(.replace))
                    .allowsHitTesting(false)
            }
            .frame(width: 56, height: 56)
            .contentShape(Circle())
        }
        .buttonStyle(BrowserBubbleButtonStyle(reduceMotion: reduceMotion))
        .glassEffect(.regular.interactive(), in: Circle())
        .overlay {
            Circle()
                .stroke(Color.white.opacity(isExpanded ? 0.28 : 0.18), lineWidth: 0.9)
                .allowsHitTesting(false)
        }
        .shadow(color: Color.black.opacity(0.52), radius: 16, y: 8)
        .shadow(color: Color.accentColor.opacity(isExpanded ? 0.30 : 0.16), radius: 14)
        .position(position ?? restingPosition)
        .zIndex(30)
        .simultaneousGesture(dragGesture)
        .accessibilityLabel(isExpanded ? "Close browser controls" : "Browser controls")
        .accessibilityHint("Double tap to toggle controls. Drag to reposition.")
        .accessibilityIdentifier("browser.controls")
    }

    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 7, coordinateSpace: .named("browserChrome"))
            .onChanged { value in
                if dragOrigin == nil {
                    dragOrigin = position ?? restingPosition
                    isDragging = true
                    menuWillClose()
                    HapticManager.play(.selection)
                }
                guard let dragOrigin else { return }
                position = constrained(CGPoint(
                    x: dragOrigin.x + value.translation.width,
                    y: dragOrigin.y + value.translation.height
                ))
            }
            .onEnded { _ in
                guard let current = position else {
                    resetDragState()
                    return
                }
                let snappedX = current.x < movementBounds.midX ? movementBounds.minX : movementBounds.maxX
                let destination = constrained(CGPoint(x: snappedX, y: current.y))
                withAnimation(reduceMotion ? NBAnimation.quick : .spring(response: 0.38, dampingFraction: 0.78)) {
                    position = destination
                }
                HapticManager.play(.light)
                resetDragState()
            }
    }

    private func constrained(_ point: CGPoint) -> CGPoint {
        CGPoint(
            x: min(max(point.x, movementBounds.minX), movementBounds.maxX),
            y: min(max(point.y, movementBounds.minY), movementBounds.maxY)
        )
    }

    private func resetDragState() {
        dragOrigin = nil
        Task { @MainActor in
            await Task.yield()
            isDragging = false
        }
    }
}

private struct BrowserBubbleButtonStyle: ButtonStyle {
    let reduceMotion: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(reduceMotion || !configuration.isPressed ? 1 : 0.90)
            .brightness(configuration.isPressed ? 0.10 : 0)
            .animation(reduceMotion ? nil : .spring(response: 0.22, dampingFraction: 0.72), value: configuration.isPressed)
    }
}
