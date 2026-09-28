import SwiftUI

struct NBUsageRing: View {
    let progress: Double
    let value: String
    let label: String
    var tint: Color = .accentColor

    var body: some View {
        ZStack {
            Circle().stroke(Color.white.opacity(0.08), lineWidth: 11)
            Circle()
                .trim(from: 0, to: min(max(progress, 0), 1))
                .stroke(tint, style: StrokeStyle(lineWidth: 11, lineCap: .round))
                .rotationEffect(.degrees(-90))
            VStack(spacing: NBSpacing.xSmall) {
                Text(value)
                    .font(.system(.title2, design: .rounded, weight: .bold))
                    .contentTransition(.numericText())
                Text(label)
                    .font(.caption)
                    .foregroundStyle(NBColor.secondaryText)
            }
        }
        .frame(width: 150, height: 150)
    }
}
