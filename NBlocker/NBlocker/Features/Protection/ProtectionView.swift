import SwiftUI

struct ProtectionView: View {
    @Environment(AppEnvironment.self) private var environment

    var body: some View {
        let activeRoutine = environment.routines.activeRoutine() ?? environment.routines.routines.first ?? .normal
        ScrollView {
            VStack(spacing: NBSpacing.large) {
                NBSectionHeader(title: "Protection", subtitle: "Filtering works now; system controls depend on signing")

                ZStack {
                    Circle().fill(Color.accentColor.opacity(0.1)).frame(width: 170, height: 170)
                    Image(systemName: environment.screenTime.canManageApps ? "shield.checkered" : "shield.lefthalf.filled")
                        .font(.system(size: 70))
                        .foregroundStyle(environment.screenTime.canManageApps ? NBColor.success : Color.accentColor)
                        .shadow(color: Color.accentColor.opacity(0.3), radius: 28)
                }

                NBCard {
                    HStack(alignment: .top, spacing: NBSpacing.medium) {
                        Image(systemName: "checkmark.seal")
                            .foregroundStyle(environment.screenTime.canManageApps ? NBColor.success : NBColor.warning)
                        VStack(alignment: .leading, spacing: 4) {
                            Text(environment.screenTime.state.title).font(.headline)
                            Text(environment.screenTime.state.explanation)
                                .font(.subheadline)
                                .foregroundStyle(NBColor.secondaryText)
                        }
                    }
                }

                ProtectedAppsView(state: environment.screenTime.state)
                StrictModeView(routine: activeRoutine) { environment.routines.save($0) }
            }
            .padding(NBSpacing.standard)
        }
        .navigationTitle("Protection")
        .toolbarTitleDisplayMode(.inline)
        .task { environment.screenTime.refresh() }
        .accessibilityIdentifier("screen.protection")
    }
}
