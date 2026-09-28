import SwiftUI

struct CurrentRoutineCard: View {
    let routine: Routine?

    var body: some View {
        NBCard {
            HStack(spacing: NBSpacing.medium) {
                Image(systemName: routine?.strictMode.isEnabled == true ? "lock.shield.fill" : "clock.badge.checkmark")
                    .font(.title2)
                    .foregroundStyle(routine?.strictMode.isEnabled == true ? NBColor.warning : Color.accentColor)
                VStack(alignment: .leading, spacing: 3) {
                    Text("Current Routine").font(.caption).foregroundStyle(NBColor.secondaryText)
                    Text(routine?.name ?? "No scheduled routine").font(.headline)
                }
                Spacer()
                Text(routine?.strictMode.isEnabled == true ? "Strict" : "Normal")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(NBColor.secondaryText)
            }
        }
    }
}
