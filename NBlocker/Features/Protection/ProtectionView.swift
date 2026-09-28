import SwiftUI

struct ProtectionView: View {
    @Environment(AppEnvironment.self) private var environment

    var body: some View {
        let activeRoutine = environment.routines.activeRoutine() ?? environment.routines.routines.first ?? .normal

        ScrollView {
            VStack(spacing: NBSpacing.medium) {
                NBSectionHeader(
                    title: "Protection",
                    subtitle: "Filtering works now. System controls depend on signing."
                )

                ZStack {
                    Circle()
                        .fill(Color.accentColor.opacity(0.10))
                        .frame(width: 112, height: 112)

                    Image(systemName: environment.screenTime.canManageApps ? "shield.checkered" : "shield.lefthalf.filled")
                        .font(.system(size: 46))
                        .foregroundStyle(environment.screenTime.canManageApps ? NBColor.success : Color.accentColor)
                        .shadow(color: Color.accentColor.opacity(0.24), radius: 18)
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
            .padding(.horizontal, NBSpacing.standard)
            .padding(.top, NBSpacing.small)
            .padding(.bottom, NBSpacing.medium)
        }
        .scrollIndicators(.hidden)
        .toolbar(.hidden, for: .navigationBar)
        .task { environment.screenTime.refresh() }
        .accessibilityIdentifier("screen.protection")
    }
}
