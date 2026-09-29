import SwiftUI

struct CurrentRoutineCard: View {
    let routine: Routine?

    var body: some View {
        NBCard {
            HStack(spacing: NBSpacing.medium) {
                Image(systemName: routine?.strictMode.isEnabled == true ? "lock.shield.fill" : "clock.badge.checkmark")
                    .font(.body.weight(.semibold))
                    .foregroundStyle(routine?.strictMode.isEnabled == true ? NBColor.warning : Color.accentColor)
                VStack(alignment: .leading, spacing: 3) {
                    Text("Current Routine").font(.caption2).foregroundStyle(NBColor.secondaryText)
                    Text(routine?.name ?? "No scheduled routine").font(.subheadline.weight(.semibold))
                }
                Spacer()
                Text(routine?.strictMode.isEnabled == true ? "Strict" : "Normal")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(NBColor.secondaryText)
            }
        }
    }
}
