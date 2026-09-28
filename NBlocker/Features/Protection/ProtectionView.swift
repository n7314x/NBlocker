import SwiftUI

struct ProtectionView: View {
    @Environment(AppEnvironment.self) private var environment

    var body: some View {
        let activeRoutine = environment.routines.activeRoutine() ?? environment.routines.routines.first ?? .normal

        ScrollView {
            VStack(spacing: NBSpacing.large) {
                Text("Filtering works now. System controls depend on signing capabilities.")
                    .font(.footnote)
                    .foregroundStyle(NBColor.secondaryText)
                    .frame(maxWidth: .infinity, alignment: .leading)

                ZStack {
                    Circle()
                        .fill(Color.accentColor.opacity(0.10))
                        .frame(width: 156, height: 156)

                    Image(systemName: environment.screenTime.canManageApps ? "shield.checkered" : "shield.lefthalf.filled")
                        .font(.system(size: 64))
                        .foregroundStyle(environment.screenTime.canManageApps ? NBColor.success : Color.accentColor)
                        .shadow(color: Color.accentColor.opacity(0.28), radius: 24)
                }
                .frame(maxWidth: .infinity)

                NBCard {
                    HStack(alignment: .top, spacing: NBSpacing.medium) {
                        Image(systemName: "checkmark.seal")
                            .foregroundStyle(environment.screenTime.canManageApps ? NBColor.success : NBColor.warning)

                        VStack(alignment: .leading, spacing: 4) {
                            Text(environment.screenTime.state.title)
                                .font(.headline)
                            Text(environment.screenTime.state.explanation)
                                .font(.subheadline)
                                .foregroundStyle(NBColor.secondaryText)
                        }
                    }
                }

                ProtectedAppsView(state: environment.screenTime.state)
                StrictModeView(routine: activeRoutine) { environment.routines.save($0) }
            }
            .padding(.horizontal, NBSpacing.standard)
            .padding(.top, NBSpacing.medium)
            .padding(.bottom, NBSpacing.large)
        }
        .scrollIndicators(.hidden)
        .navigationTitle("Protection")
        .toolbarTitleDisplayMode(.inline)
        .task { environment.screenTime.refresh() }
        .accessibilityIdentifier("screen.protection")
    }
}
