import SwiftUI

struct InstagramAccountSwitcherView: View {
    @Environment(\.dismiss) private var dismiss
    let continueInInstagram: () -> Void

    var body: some View {
        NavigationStack {
            VStack(spacing: NBSpacing.large) {
                NBPlatformIcon(platform: .instagram, size: 72)

                VStack(spacing: NBSpacing.small) {
                    Text("Instagram Accounts")
                        .font(.title2.bold())
                    Text("Use Instagram’s own account screen to sign in or switch profiles. Credentials and cookies stay in WebKit.")
                        .font(.subheadline)
                        .foregroundStyle(NBColor.secondaryText)
                        .multilineTextAlignment(.center)
                }

                Button("Continue in Instagram") {
                    continueInInstagram()
                    dismiss()
                }
                .buttonStyle(.glassProminent)
                .tint(Platform.instagram.accentColor)
                .accessibilityIdentifier("browser.accounts.continue")
            }
            .padding(NBSpacing.xLarge)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(NBColor.canvas)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
}
