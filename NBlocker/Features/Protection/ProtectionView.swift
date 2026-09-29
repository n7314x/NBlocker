import SwiftUI

struct ProtectionView: View {
    @Environment(AppEnvironment.self) private var environment

    var body: some View {
        let activeRoutine = environment.routines.activeRoutine() ?? environment.routines.routines.first ?? .normal

        NBRootScrollView {
            NBSectionHeader(
                title: "Protection",
                subtitle: "Filtering works now. System controls depend on signing."
            )

            ZStack {
                Circle()
                    .fill(Color.accentColor.opacity(0.10))
                    .frame(width: 88, height: 88)
                    .allowsHitTesting(false)

                Image(systemName: environment.screenTime.canManageApps ? "shield.checkered" : "shield.lefthalf.filled")
                    .font(.system(size: 36))
                    .foregroundStyle(environment.screenTime.canManageApps ? NBColor.success : Color.accentColor)
                    .shadow(color: Color.accentColor.opacity(0.20), radius: 12)
            }
            .frame(maxWidth: .infinity)

            NBCard {
                HStack(alignment: .top, spacing: NBSpacing.medium) {
                    Image(systemName: "checkmark.seal")
                        .font(.subheadline)
                        .foregroundStyle(environment.screenTime.canManageApps ? NBColor.success : NBColor.warning)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(environment.screenTime.state.title)
                            .font(.subheadline.weight(.semibold))
                        Text(environment.screenTime.state.explanation)
                            .font(.caption2)
                            .foregroundStyle(NBColor.secondaryText)
                    }
                }
            }

            ProtectedAppsView(state: environment.screenTime.state)
            StrictModeView(routine: activeRoutine) { environment.routines.save($0) }
        }
        .toolbar(.hidden, for: .navigationBar)
        .task { environment.screenTime.refresh() }
        .accessibilityIdentifier("screen.protection")
    }
}
