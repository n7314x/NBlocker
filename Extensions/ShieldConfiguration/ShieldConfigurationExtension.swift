import ManagedSettings
import ManagedSettingsUI
import UIKit

final class ShieldConfigurationExtension: ShieldConfigurationDataSource {
    private let base = ShieldConfiguration(
        backgroundBlurStyle: .systemUltraThinMaterialDark,
        backgroundColor: .black,
        icon: UIImage(systemName: "shield.lefthalf.filled"),
        title: ShieldConfiguration.Label(text: "Protected by NBlocker", color: .white),
        subtitle: ShieldConfiguration.Label(
            text: "Return when your routine ends or use the configured override in NBlocker.",
            color: .secondaryLabel
        ),
        primaryButtonLabel: ShieldConfiguration.Label(text: "Open NBlocker", color: .black),
        primaryButtonBackgroundColor: .white,
        secondaryButtonLabel: ShieldConfiguration.Label(text: "Not now", color: .white)
    )

    override func configuration(shielding application: Application) -> ShieldConfiguration { base }
    override func configuration(shielding application: Application, in category: ActivityCategory) -> ShieldConfiguration { base }
    override func configuration(shielding webDomain: WebDomain) -> ShieldConfiguration { base }
    override func configuration(shielding webDomain: WebDomain, in category: ActivityCategory) -> ShieldConfiguration { base }
}
