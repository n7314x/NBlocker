import SwiftUI

struct StrictModeView: View {
    let routine: Routine
    let update: (Routine) -> Void
    @State private var overrideRequest: StrictOverrideRequest?

    var body: some View {
        NBCard {
            VStack(alignment: .leading, spacing: NBSpacing.medium) {
                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Strict Mode").font(.subheadline.weight(.semibold))
                        Text("Adds deliberate override friction inside NBlocker")
                            .font(.caption2)
                            .foregroundStyle(NBColor.secondaryText)
                    }
                    Spacer()
                    if routine.strictMode.isEnabled {
                        Button("Override…") {
                            requestOverride()
                        }
                        .font(.caption.weight(.semibold))
                    }
                }

                NBStrictModeSlider(isActive: routine.strictMode.isEnabled) {
                    var copy = routine
                    copy.strictMode.isEnabled = true
                    update(copy)
                }

                Picker("Override behavior", selection: Binding(
                    get: { routine.strictMode.overridePolicy },
                    set: { policy in
                        var copy = routine
                        copy.strictMode.overridePolicy = policy
                        update(copy)
                    }
                )) {
                    ForEach(StrictOverridePolicy.allCases) { policy in
                        Text(policy.title).tag(policy)
                    }
                }
                .pickerStyle(.menu)
                .font(.caption)

                Text("Without Screen Time entitlement support, this affects only controls managed by NBlocker.")
                    .font(.caption2)
                    .foregroundStyle(NBColor.quietText)
            }
        }
        .sheet(item: $overrideRequest) { request in
            StrictOverrideSheet(request: request) {
                disableStrictMode()
                overrideRequest = nil
            }
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
            .presentationCornerRadius(NBRadius.sheet)
            .presentationBackground(NBColor.sheet)
        }
    }

    private func requestOverride() {
        let policy = routine.strictMode.overridePolicy
        if policy == .immediate {
            disableStrictMode()
            return
        }

        overrideRequest = StrictOverrideRequest(
            policy: policy,
            requestedAt: .now,
            routineEndsAt: routine.schedule.activeIntervalEnd(containing: .now)
        )
    }

    private func disableStrictMode() {
        var copy = routine
        copy.strictMode.isEnabled = false
        update(copy)
        HapticManager.play(.success)
    }
}

private struct StrictOverrideRequest: Identifiable {
    let id = UUID()
    let policy: StrictOverridePolicy
    let requestedAt: Date
    let routineEndsAt: Date?

    var timing: StrictModeTiming {
        StrictModeTiming(requestedAt: requestedAt, policy: policy, routineEndsAt: routineEndsAt)
    }
}

private struct StrictOverrideSheet: View {
    let request: StrictOverrideRequest
    let disable: () -> Void

    @Environment(\.dismiss) private var dismiss
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var holdStartedAt: Date?

    var body: some View {
        NavigationStack {
            TimelineView(.periodic(from: .now, by: 0.1)) { context in
                VStack(spacing: NBSpacing.large) {
                    Spacer()

                    VStack(spacing: NBSpacing.small) {
                        Text("Strict Mode Override")
                            .font(.title2.bold())
                        Text(explanation)
                            .font(.subheadline)
                            .foregroundStyle(NBColor.secondaryText)
                            .multilineTextAlignment(.center)
                    }

                    if request.policy == .holdFiveSeconds {
                        holdControl(at: context.date)
                    } else {
                        timedControl(at: context.date)
                    }

                    Text("This friction is enforced by NBlocker. It is not a system-level app restriction.")
                        .font(.caption)
                        .foregroundStyle(NBColor.quietText)
                        .multilineTextAlignment(.center)

                    Spacer()

                    Button("Keep Strict Mode On") {
                        dismiss()
                    }
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color.white.opacity(0.12), in: Capsule())
                }
                .padding(NBSpacing.xLarge)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .background(NBColor.canvas.ignoresSafeArea())
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    @ViewBuilder
    private func holdControl(at date: Date) -> some View {
        let progress = holdStartedAt.map {
            min(max(date.timeIntervalSince($0) / 5, 0), 1)
        } ?? 0

        VStack(spacing: NBSpacing.large) {
            Button {} label: {
                ZStack {
                    Circle()
                        .stroke(NBColor.warning.opacity(0.20), lineWidth: 10)
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(NBColor.warning, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                    Circle()
                        .fill(NBColor.warning.opacity(0.12))
                        .padding(15)
                    Image(systemName: "lock.open.fill")
                        .font(.system(size: 44, weight: .semibold))
                        .foregroundStyle(.white)
                }
                .frame(width: 184, height: 184)
            }
            .buttonStyle(.plain)
            .scaleEffect(reduceMotion || holdStartedAt == nil ? 1 : 0.97)
            .animation(reduceMotion ? nil : NBAnimation.quick, value: holdStartedAt == nil)
            .onLongPressGesture(minimumDuration: 5, maximumDistance: 44) {
                disable()
            } onPressingChanged: { isPressing in
                holdStartedAt = isPressing ? .now : nil
            }
            .accessibilityLabel("Turn off Strict Mode")
            .accessibilityHint("Hold continuously for five seconds. Assistive activation confirms immediately.")
            .accessibilityAction { disable() }

            Text("Hold the lock for 5 seconds to turn off")
                .font(.headline)
                .multilineTextAlignment(.center)
        }
    }

    @ViewBuilder
    private func timedControl(at date: Date) -> some View {
        let timing = request.timing
        let isAvailable = timing.isAvailable(at: date)

        if let availableAt = timing.availableAt {
            if isAvailable {
                Button("Turn Off Strict Mode", action: disable)
                    .buttonStyle(.glassProminent)
            } else {
                VStack(spacing: NBSpacing.medium) {
                    ProgressView(value: timing.progress(at: date))
                        .tint(NBColor.warning)
                    Text(remainingText(until: availableAt, now: date))
                        .font(.title3.monospacedDigit().weight(.semibold))
                        .contentTransition(.numericText())
                    Button("Waiting…") {}
                        .buttonStyle(.glass)
                        .disabled(true)
                }
            }
        } else {
            Label("No active routine end is available", systemImage: "calendar.badge.exclamationmark")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(NBColor.secondaryText)
        }
    }

    private var explanation: String {
        switch request.policy {
        case .holdFiveSeconds:
            "Keep pressing without lifting to confirm this override."
        case .unavailableUntilRoutineEnds:
            "The override becomes available when the current routine interval ends."
        default:
            "Wait for the configured delay before confirming the override."
        }
    }

    private func remainingText(until date: Date, now: Date) -> String {
        let seconds = max(0, Int(ceil(date.timeIntervalSince(now))))
        if seconds >= 60 {
            return "\(seconds / 60)m \(seconds % 60)s remaining"
        }
        return "\(seconds)s remaining"
    }
}
