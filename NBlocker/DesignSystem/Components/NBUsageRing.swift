import SwiftUI

struct NBUsageRing: View {
    let progress: Double
    let value: String
    let label: String
    var tint: Color = .accentColor

    var body: some View {
        ZStack {
            Circle().stroke(Color.white.opacity(0.10), lineWidth: 9)
            Circle()
                .trim(from: 0, to: min(max(progress, 0), 1))
                .stroke(tint, style: StrokeStyle(lineWidth: 9, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .shadow(color: tint.opacity(0.28), radius: 8)
            VStack(spacing: NBSpacing.xSmall) {
                Text(value)
                    .font(.system(.title3, design: .rounded, weight: .bold))
                    .contentTransition(.numericText())
                Text(label)
                    .font(.caption)
                    .foregroundStyle(NBColor.secondaryText)
            }
        }
        .frame(width: 96, height: 96)
    }
}
