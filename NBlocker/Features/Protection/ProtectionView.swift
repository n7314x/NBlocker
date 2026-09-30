import SwiftUI

struct ProtectionView: View {
    @Environment(AppEnvironment.self) private var environment
    @State private var showsCapabilityInfo = false

    var body: some View {
        let activeRoutine = environment.routines.activeRoutine() ?? environment.routines.routines.first ?? .normal

        NBRootScrollView(spacing: NBSpacing.xLarge) {
            NBScreenHeader("Protection") {
                Button {
                    showsCapabilityInfo = true
                } label: {
                    Image(systemName: "questionmark.circle")
                        .font(.title2.weight(.semibold))
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.plain)
                .foregroundStyle(NBColor.secondaryText)
                .accessibilityLabel("About Protection")
            }

            protectionHero
                .frame(maxWidth: .infinity)

            NBCard(padding: NBSpacing.standard) {
                HStack(alignment: .top, spacing: NBSpacing.standard) {
                    Image(systemName: environment.screenTime.canManageApps ? "checkmark.seal.fill" : "exclamationmark.shield.fill")
                        .font(.title3)
                        .foregroundStyle(environment.screenTime.canManageApps ? NBColor.success : NBColor.warning)

                    VStack(alignment: .leading, spacing: 3) {
                        Text(environment.screenTime.state.title)
                            .font(.headline.weight(.semibold))
                        Text("NBlocker web filtering remains available.")
                            .font(.subheadline)
                            .foregroundStyle(NBColor.secondaryText)
                    }
                }
            }

            ProtectedAppsView(state: environment.screenTime.state)
            StrictModeView(routine: activeRoutine) { environment.routines.save($0) }
        }
        .toolbar(.hidden, for: .navigationBar)
        .task { environment.screenTime.refresh() }
        .sheet(isPresented: $showsCapabilityInfo) {
            ProtectionInfoSheet(state: environment.screenTime.state)
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
                .presentationCornerRadius(NBRadius.sheet)
                .presentationBackground(NBColor.sheet)
        }
        .accessibilityIdentifier("screen.protection")
    }

    private var protectionHero: some View {
        ZStack(alignment: .bottom) {
            Circle()
                .fill(Color.accentColor.opacity(0.12))
                .frame(width: 168, height: 168)
                .blur(radius: 12)

            Circle()
                .fill(NBColor.card)
                .frame(width: 140, height: 140)
                .overlay {
                    Circle().stroke(Color.accentColor.opacity(0.34), lineWidth: 1)
                }

            Image(systemName: environment.screenTime.canManageApps ? "shield.checkered" : "shield.lefthalf.filled")
                .font(.system(size: 62, weight: .medium))
                .foregroundStyle(environment.screenTime.canManageApps ? NBColor.success : Color.accentColor)
                .frame(width: 140, height: 140)

            HStack(spacing: -8) {
                NBPlatformIcon(platform: .instagram, size: 38)
                NBPlatformIcon(platform: .youtube, size: 38)
            }
            .offset(y: 12)
        }
        .frame(height: 176)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Instagram and YouTube web filtering")
    }
}

private struct ProtectionInfoSheet: View {
    let state: ScreenTimeCapabilityState

    var body: some View {
        VStack(alignment: .leading, spacing: NBSpacing.large) {
            Image(systemName: "shield.lefthalf.filled")
                .font(.system(size: 34, weight: .semibold))
                .foregroundStyle(Color.accentColor)

            Text("Protection levels")
                .font(.title.bold())

            Text(state.explanation)
                .font(.body)
                .foregroundStyle(NBColor.secondaryText)

            Text("Strict Mode adds deliberate friction only to controls managed by NBlocker. It is not tamper-proof or system-enforced in the ordinary sideload build.")
                .font(.body)
                .foregroundStyle(NBColor.secondaryText)

            Spacer()
        }
        .padding(NBSpacing.xLarge)
    }
}
