import SwiftUI

struct BrowserMetricsBar: View {
    let model: WebViewModel

    var body: some View {
        TimelineView(.periodic(from: .now, by: 1)) { context in
            HStack(spacing: NBSpacing.small) {
                Text(statusText(at: context.date))
                    .font(.caption2.monospacedDigit().weight(.semibold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.72)

                Spacer(minLength: NBSpacing.small)

                if model.state.metrics.blockable > 0 {
                    Button("Block these", action: model.blockVisibleDetections)
                        .font(.caption2.weight(.bold))
                        .buttonStyle(.glassProminent)
                        .controlSize(.mini)
                        .tint(model.platform.accentColor)
                        .accessibilityIdentifier("browser.blockDetected")
                }
            }
            .padding(.leading, NBSpacing.standard)
            .padding(.trailing, NBSpacing.small)
            .frame(minHeight: 38)
            .glassEffect(.regular, in: Capsule())
        }
        .accessibilityIdentifier("browser.metrics")
    }

    private func statusText(at date: Date) -> String {
        let elapsed = model.session.elapsedText(at: date)
        let metrics = model.state.metrics
        guard model.isFilteringEnabled else { return "\(elapsed) • filters off" }
        guard metrics.hasReport else { return "\(elapsed) • filters active" }
        return "\(elapsed) • \(metrics.ads) ads • \(metrics.suggested) suggested"
    }
}
