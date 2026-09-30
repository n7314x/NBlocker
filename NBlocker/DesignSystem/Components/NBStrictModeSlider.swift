import SwiftUI

struct NBStrictModeSlider: View {
    let isActive: Bool
    let activate: () -> Void
    @State private var drag: CGFloat = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        GeometryReader { proxy in
            let thumb: CGFloat = 62
            let travel = max(0, proxy.size.width - thumb - 8)
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(isActive ? NBColor.success.opacity(0.14) : Color.white.opacity(0.055))
                    .overlay {
                        Capsule().stroke(NBColor.border, lineWidth: 1)
                    }
                Text(isActive ? "Strict Mode active" : "Slide to activate")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(isActive ? NBColor.success : NBColor.secondaryText)
                    .frame(maxWidth: .infinity)
                Circle()
                    .fill(isActive ? NBColor.success : NBColor.warning)
                    .overlay {
                        Image(systemName: isActive ? "lock.fill" : "chevron.right.2")
                            .font(.system(size: 19, weight: .bold))
                            .foregroundStyle(.white)
                    }
                    .padding(4)
                    .frame(width: thumb, height: thumb)
                    .offset(x: isActive ? travel : min(max(drag, 0), travel))
                    .gesture(
                        DragGesture(minimumDistance: 3)
                            .onChanged { value in
                                guard !isActive else { return }
                                drag = value.translation.width * (value.translation.width > travel * 0.8 ? 0.72 : 1)
                            }
                            .onEnded { value in
                                guard !isActive else { return }
                                if value.translation.width >= travel * 0.82 {
                                    HapticManager.play(.success)
                                    activate()
                                }
                                withAnimation(reduceMotion ? nil : NBAnimation.interactive) { drag = 0 }
                            }
                    )
            }
        }
        .frame(height: 70)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(isActive ? "Strict Mode active" : "Activate Strict Mode")
        .accessibilityAddTraits(.isButton)
        .accessibilityAction { if !isActive { activate() } }
    }
}
